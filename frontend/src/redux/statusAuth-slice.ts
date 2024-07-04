import { createSlice, PayloadAction } from "@reduxjs/toolkit";

type TypeStatusAuth = {
    status: boolean,
    id: string,
    name: string,
    surname: string
}

type TypeValue = {
    value: TypeStatusAuth
}

const initialState: TypeValue = {
    value: {
        status: false,
        id: '',
        name: '',
        surname: ''
    },
}

const statusAuthSlice = createSlice({
    name: '@@statusAuth',
    initialState,
    reducers: {
        setStatusAuth: (state, action: PayloadAction<TypeStatusAuth>) =>{
            state.value = action.payload
        }
    }
})

export default statusAuthSlice.reducer
export const {setStatusAuth} = statusAuthSlice.actions