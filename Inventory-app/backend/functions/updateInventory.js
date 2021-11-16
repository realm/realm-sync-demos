exports = async function (changeEvent) {
  async function asyncForEach(array, callback) {
    for (let index = 0; index < array.length; index++) {
      await callback(array[index], index);
    }
  }

  const fullDocument = changeEvent.fullDocument;

  const collection = context.services
    .get("realm-cluster")
    .db("sandbox-db")
    .collection("StoreInventory");

  const jobCollection = context.services
    .get("realm-cluster")
    .db("sandbox-db")
    .collection("Jobs");

  try {
    const { sourceStore, destinationStore, status, _id } = fullDocument;
    const jobs = await jobCollection
      .aggregate([
        {
          $match: {
            _id,
          },
        },
        {
          $lookup: {
            from: "ProductQuantity",
            localField: "products",
            foreignField: "_id",
            as: "products",
          },
        },
        {
          $unwind: "$products",
        },
        {
          $lookup: {
            from: "Products",
            localField: "products.product",
            foreignField: "_id",
            as: "products.product",
          },
        },
        {
          $unwind: "$products.product",
        },
      ])
      .toArray();

    await asyncForEach(jobs, async ({ products: { product, quantity } }) => {
      switch (status) {
        // case "to-do":
        //   await collection.updateOne(
        //     { productId: product._id, storeId: sourceStore },
        //     {
        //       $inc: {
        //         quantity: quantity,
        //       },
        //     }
        //   );
        //   break;
        case "in-progress":
          await collection.updateOne(
            { productId: product._id, storeId: sourceStore },
            {
              $inc: {
                quantity: -quantity,
              },
            }
          );
          break;
        case "done":
          const sI = await collection.findOne({
            productId: product._id,
            storeId: destinationStore,
          });
          if (sI) {
            await collection.updateOne(
              { productId: product._id, storeId: destinationStore },
              {
                $inc: {
                  quantity: quantity,
                },
              }
            );
          } else {
            await collection.insertOne({
              image: product.image,
              productName: product.name,
              storeId: destinationStore,
              productId: product._id,
              _partition: `store=${destinationStore.toString()}`,
              quantity: quantity,
            });
          }
          break;
      }
    });
  } catch (e) {
    console.log(e);
  }

  return true;
};
