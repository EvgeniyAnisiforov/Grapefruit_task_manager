from typing import List

from fastapi import APIRouter, Depends

from app.dependencies.services import get_kanban_service
from app.models.kanban import TaskRequest, TaskResponse, TaskUpdateRequest, TaskUpdateStatusChangeRequest, \
    TaskUpdateOrderRequest

router = APIRouter(prefix="/kanban", tags=["kanban"])


@router.post(
    path="/task/add",
    description="Метод для добавления задачи",
)
async def add_task(
        request: TaskRequest,
        kanban_service=Depends(get_kanban_service)
):
    task_id = await kanban_service.add_task(
        request.user_id, request.task, request.level
    )
    return {"task_id": task_id}


@router.put(
    path="/task/update",
    description="Метод для обновления задачи",
)
async def update_task(
        request: TaskUpdateRequest,
        kanban_service=Depends(get_kanban_service)
):
    update_result = await kanban_service.update_task(
        request.task_id, request.task, request.level
    )
    return {"success": update_result}


@router.delete(
    path="/task/delete",
    description="Метод для удаления задачи",
)
async def delete_task(
        task_id: int,
        kanban_service=Depends(get_kanban_service)
):
    delete_result = await kanban_service.delete_task(task_id)
    return {"deleted": delete_result}


@router.get(
    path="/tasks/{user_id}",
    description="Метод для получения задач пользователя",
    response_model=List[TaskResponse]
)
async def get_tasks_by_user_id(
        user_id: int,
        kanban_service=Depends(get_kanban_service)
):
    tasks = await kanban_service.get_tasks_by_user_id(user_id)
    return tasks


@router.put(
    path="/task/update_order",
    description="Метод для обновления порядка задач",
)
async def update_task_order(
        request: TaskUpdateOrderRequest,
        kanban_service=Depends(get_kanban_service)
):
    update_result = await kanban_service.update_task_order(
        request.task_id_old, request.task_id_new
    )
    return {"success": update_result}


@router.put(
    path="/task/change_status",
    description="Метод для изменения статуса задачи",
)
async def change_task_status(
        request: TaskUpdateStatusChangeRequest,
        kanban_service=Depends(get_kanban_service)
):
    change_result = await kanban_service.change_task_status(
        request.task_id_old, request.task_id_new
    )
    return {"success": change_result}
