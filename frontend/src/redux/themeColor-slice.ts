import { createSlice, PayloadAction } from "@reduxjs/toolkit";


type TypeThemeColor = {
    value: string
}

const initialState: TypeThemeColor = {
    value: 'bg-gradient-to-r from-orange-400 to-red-500'
}

const themeColorSlice = createSlice({
    name: '@@themeColor',
    initialState,
    reducers: {
        setThemeColor: (state, action: PayloadAction<string>)=> {
            state.value = action.payload
        }
    }
})

export default themeColorSlice.reducer
export const {setThemeColor} = themeColorSlice.actions