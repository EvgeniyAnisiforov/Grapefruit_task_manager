import { configureStore } from "@reduxjs/toolkit";
import { AuthApi } from "./API/AuthApi";
import { RegApi } from "./API/RegApi";
import { KanbanApi } from "./API/KanbanApi";
import  statusAuthSlice from "./statusAuth-slice";
import { CaptchaApi } from "./API/CaptchaApi";

export const store = configureStore({
    reducer:{
        [AuthApi.reducerPath]: AuthApi.reducer,
        [RegApi.reducerPath]: RegApi.reducer,
        [KanbanApi.reducerPath]: KanbanApi.reducer,
        [CaptchaApi.reducerPath]: CaptchaApi.reducer,
        statusAuth: statusAuthSlice,
    },
    middleware: (getDefaultMiddleware) => getDefaultMiddleware().concat(AuthApi.middleware, RegApi.middleware, KanbanApi.middleware, CaptchaApi.middleware),
    devTools: true
})

export type RootState = ReturnType<typeof store.getState>
export type AppDispatch = typeof store.dispatch