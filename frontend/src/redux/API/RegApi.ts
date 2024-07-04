import { createApi, fetchBaseQuery } from "@reduxjs/toolkit/query/react"

export const RegApi = createApi({
  reducerPath: "RegApi",
  baseQuery: fetchBaseQuery({ baseUrl: 'http://localhost:8081/' }),
  endpoints: (build) => ({
    postReg: build.mutation({
      query: (body) => ({
        url: 'api/auth/registration',
        method: "POST",
        body,
      }),
    }),
  }),
})

export const {usePostRegMutation} = RegApi