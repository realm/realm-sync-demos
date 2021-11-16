import React from "react";

type ProviderProps = {
  children?: React.ReactNode;
};

export function generateContext<P, V>(useValue: (props: P) => V) {
  const Context = React.createContext({} as V);
  const Provider: React.FC<ProviderProps & P> = (props) => {
    const value = useValue(props);
    const { children } = props;
    return <Context.Provider value={value}>{children}</Context.Provider>;
  };
  const useContext = () => React.useContext(Context);
  return {
    useContext,
    Context,
    Provider,
  };
}
