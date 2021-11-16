/// <reference types="react-scripts" />


type Reducer<State, Action> = 
  (state: State, action: Action) => State;