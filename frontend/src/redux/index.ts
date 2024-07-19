import { configureStore, combineReducers } from "@reduxjs/toolkit"
import {
  persistStore,
  persistReducer,
  FLUSH,
  REHYDRATE,
  PAUSE,
  PERSIST,
  PURGE,
  REGISTER,
} from "redux-persist"
import storage from "redux-persist/lib/storage"
import { AuthApi } from "./API/AuthApi"
import { RegApi } from "./API/RegApi"
import { KanbanApi } from "./API/KanbanApi"
import statusAuthSlice from "./statusAuth-slice"
import themeColorSlice from "./themeColor-slice"
import { CaptchaApi } from "./API/CaptchaApi"

const rootReducer = combineReducers({
  [AuthApi.reducerPath]: AuthApi.reducer,
  [RegApi.reducerPath]: RegApi.reducer,
  [KanbanApi.reducerPath]: KanbanApi.reducer,
  [CaptchaApi.reducerPath]: CaptchaApi.reducer,
  statusAuth: statusAuthSlice,
  themeColor: themeColorSlice,
})

const persistConfig = {
  key: "root",
  storage,
  blacklist: [
    AuthApi.reducerPath,
    RegApi.reducerPath,
    KanbanApi.reducerPath,
    CaptchaApi.reducerPath,
  ],
}

const persistedReducer = persistReducer(persistConfig, rootReducer)

const store = configureStore({
  reducer: persistedReducer,
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware({
      serializableCheck: {
        ignoredActions: [FLUSH, REHYDRATE, PAUSE, PERSIST, PURGE, REGISTER],
      },
    }).concat(
      AuthApi.middleware,
      RegApi.middleware,
      KanbanApi.middleware,
      CaptchaApi.middleware
    ),
  devTools: true,
})
export const persistor = persistStore(store)
export default store

export type RootState = ReturnType<typeof store.getState>
export type AppDispatch = typeof store.dispatch
