import { createApi, fetchBaseQuery } from "@reduxjs/toolkit/query/react"

export const AuthApi = createApi({
  reducerPath: "AuthApi",
  baseQuery: fetchBaseQuery({ baseUrl: "http://localhost:8081/" }),
  endpoints: (build) => ({
    postAuth: build.mutation({
      query: (body) => ({
        url: "api/auth/authentication",
        method: "POST",
        body,
      }),
    }),
  }),
})

export const {usePostAuthMutation} = AuthApi