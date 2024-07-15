import { createApi, fetchBaseQuery } from "@reduxjs/toolkit/query/react";

export const KanbanApi = createApi({
    reducerPath: 'kanbanApi',
    tagTypes: ['Tasks'],
    baseQuery: fetchBaseQuery({baseUrl: 'http://localhost:8081/'}),
    endpoints: (build) => ({
        getDataKanban: build.query({
            query: (id) => `api/kanban/tasks/${id}`,
            providesTags: ['Tasks']
        }),
        addDataTask: build.mutation({
            query: (body) => ({
                url: 'api/kanban/task/add',
                method: 'POST',
                body,
            }),
            invalidatesTags: ['Tasks']
        }),
        updateTask: build.mutation({
            query: (body) => ({
                url: 'api/kanban/task/update',
                method: 'PUT',
                body
            }),
            invalidatesTags: ['Tasks']
        }),
        deleteDataTask: build.mutation({
            query: (task_id) => ({
                url: `api/kanban/task/delete?task_id=${task_id}`,
                method: 'DELETE',
            }),
            invalidatesTags: ['Tasks']
        }),
        changeStatus: build.mutation({
            query: (body)=>({
                url: '/api/kanban/task/change_status',
                method: 'PUT',
                body
            }),
            invalidatesTags: ['Tasks']
        })
    })
})

export const {useGetDataKanbanQuery, useAddDataTaskMutation, useUpdateTaskMutation, useDeleteDataTaskMutation, useChangeStatusMutation} = KanbanApi