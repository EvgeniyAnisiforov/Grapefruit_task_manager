import { createApi, fetchBaseQuery } from "@reduxjs/toolkit/query/react";

export const CaptchaApi = createApi({
    reducerPath: 'captchaApi',
    tagTypes: ['Captcha'],
    baseQuery: fetchBaseQuery({baseUrl: "http://localhost:8081/" }),
    endpoints: (build) => ({
        getCaptcha: build.query({
            query: () => 'api/captcha/get_captcha',
            providesTags: ['Captcha']
        }),
        postCaptcha: build.mutation({
            query: (body) => ({
                url: 'api/captcha/verify_captcha',
                method: 'POST',
                body
            }),
            invalidatesTags: ['Captcha']
        })
    })
})

export const {useGetCaptchaQuery, usePostCaptchaMutation} = CaptchaApi