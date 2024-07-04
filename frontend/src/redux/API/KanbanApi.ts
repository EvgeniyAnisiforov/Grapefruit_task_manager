import { createApi, fetchBaseQuery } from "@reduxjs/toolkit/query/react";

export const KanbanApi = createApi({
    reducerPath: 'kanbanApi',
    baseQuery: fetchBaseQuery({baseUrl: 'http://localhost:8081/'}),
    endpoints: (build) => ({
        getDataKanban: build.query({
            query: (id) => `api/kanban/tasks/${id}`
        })
    })
})

export const {useGetDataKanbanQuery} = KanbanApi