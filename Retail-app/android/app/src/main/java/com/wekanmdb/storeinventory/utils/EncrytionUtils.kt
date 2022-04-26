package com.wekanmdb.storeinventory.utils

import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import android.util.Base64
import android.util.Log
import com.wekanmdb.storeinventory.data.AppPreference
import io.realm.Realm
import java.nio.ByteBuffer
import java.nio.ByteOrder
import java.security.*
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.IvParameterSpec

object EncrytionUtils {

    fun getExistingKey(appPreference:AppPreference): ByteArray? {
        // open a connection to the android keystore
        val keyStore: KeyStore
        try {
            keyStore = KeyStore.getInstance("AndroidKeyStore")
            keyStore.load(null)
        } catch (e: Exception) {
            Log.e("EXAMPLE", "Failed to open the keystore.")
            throw RuntimeException(e)
        }
        try {

            // access the encrypted key that's stored in shared preferences
            val initializationVectorAndEncryptedKey = Base64.decode(appPreference.KEY, Base64.DEFAULT)
            val buffer = ByteBuffer.wrap(initializationVectorAndEncryptedKey)
            buffer.order(ByteOrder.BIG_ENDIAN)
            // extract the length of the initialization vector from the buffer
            val initializationVectorLength = buffer.int
            // extract the initialization vector based on that length
            val initializationVector = ByteArray(initializationVectorLength)
            buffer[initializationVector]
            // extract the encrypted key
            val encryptedKey = ByteArray(initializationVectorAndEncryptedKey.size
                    - Integer.BYTES
                    - initializationVectorLength)
            buffer[encryptedKey]


            // create a cipher that uses AES encryption to decrypt our key
            val cipher: Cipher
            cipher = try {
                Cipher.getInstance(
                    KeyProperties.KEY_ALGORITHM_AES
                        + "/" + KeyProperties.BLOCK_MODE_CBC
                        + "/" + KeyProperties.ENCRYPTION_PADDING_PKCS7)
            } catch (e: Exception) {
                Log.e("EXAMPLE", "Failed to create cipher.")
                throw RuntimeException(e)
            }
            // decrypt the encrypted key with the secret key stored in the keystore
            val decryptedKey: ByteArray
            decryptedKey = try {
                val secretKey = keyStore.getKey("realm_key", null) as SecretKey
                val initializationVectorSpec = IvParameterSpec(initializationVector)
                cipher.init(Cipher.DECRYPT_MODE, secretKey, initializationVectorSpec)
                cipher.doFinal(encryptedKey)
            } catch (e: InvalidKeyException) {
                Log.e("EXAMPLE", "Failed to decrypt. Invalid key.")
                throw RuntimeException(e)
            } catch (e: Exception ) {
                Log.e("EXAMPLE",
                    "Failed to decrypt the encrypted realm key with the secret key.")
                throw RuntimeException(e)
            }
            return decryptedKey // pass to a realm configuration via encryptionKey()
        }catch (e:Exception){
            return null
        }
        return null
    }


    fun getNewKey(appPreference:AppPreference): ByteArray {
        // open a connection to the android keystore
        val keyStore: KeyStore
        try {
            keyStore = KeyStore.getInstance("AndroidKeyStore")
            keyStore.load(null)
        } catch (e: Exception) {
            Log.v("EXAMPLE", "Failed to open the keystore.")
            throw RuntimeException(e)
        }
        // create a securely generated random asymmetric RSA key
        val realmKey = ByteArray(Realm.ENCRYPTION_KEY_LENGTH)
        SecureRandom().nextBytes(realmKey)
        // create a cipher that uses AES encryption -- we'll use this to encrypt our key
        val cipher: Cipher
        cipher = try {
            Cipher.getInstance(KeyProperties.KEY_ALGORITHM_AES
                    + "/" + KeyProperties.BLOCK_MODE_CBC
                    + "/" + KeyProperties.ENCRYPTION_PADDING_PKCS7)
        } catch (e: Exception) {
            Log.e("EXAMPLE", "Failed to create a cipher.")
            throw RuntimeException(e)
        }
        // generate secret key
        val keyGenerator: KeyGenerator
        keyGenerator = try {
            KeyGenerator.getInstance(
                KeyProperties.KEY_ALGORITHM_AES,
                "AndroidKeyStore")
        } catch (e: NoSuchAlgorithmException) {
            Log.e("EXAMPLE", "Failed to access the key generator.")
            throw RuntimeException(e)
        }
        val keySpec = KeyGenParameterSpec.Builder(
            "realm_key",
            KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT)
            .setBlockModes(KeyProperties.BLOCK_MODE_CBC)
            .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_PKCS7)
            .setUserAuthenticationRequired(false)
            .build()
        try {
            keyGenerator.init(keySpec)
        } catch (e: InvalidAlgorithmParameterException) {
            Log.e("EXAMPLE", "Failed to generate a secret key.")
            throw RuntimeException(e)
        }
        keyGenerator.generateKey()
        // access the generated key in the android keystore, then
        // use the cipher to create an encrypted version of the key
        val initializationVector: ByteArray
        val encryptedKeyForRealm: ByteArray
        try {
            val secretKey = keyStore.getKey("realm_key", null) as SecretKey
            cipher.init(Cipher.ENCRYPT_MODE, secretKey)
            encryptedKeyForRealm = cipher.doFinal(realmKey)
            initializationVector = cipher.iv
        } catch (e: Exception) {
            Log.e("EXAMPLE", "Failed encrypting the key with the secret key.")
            throw RuntimeException(e)
        }
        // keep the encrypted key in shared preferences
        // to persist it across application runs
        val initializationVectorAndEncryptedKey = ByteArray(Integer.BYTES +
                initializationVector.size +
                encryptedKeyForRealm.size)
        val buffer = ByteBuffer.wrap(initializationVectorAndEncryptedKey)
        buffer.order(ByteOrder.BIG_ENDIAN)
        buffer.putInt(initializationVector.size)
        buffer.put(initializationVector)
        buffer.put(encryptedKeyForRealm)
        appPreference.KEY=Base64.encodeToString(initializationVectorAndEncryptedKey, Base64.NO_WRAP)

        return realmKey // pass to a realm configuration via encryptionKey()
    }


}