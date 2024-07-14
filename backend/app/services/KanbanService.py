from collections import defaultdict
from typing import List, Dict

from app.db.PostgresRepository import PostgresRepository
from app.exceptions.exceptions import NotFoundException, ValidationException
from app.models.kanban import Task, TaskResponse


class KanbanService:
    def __init__(
            self,
            postgres_repository: PostgresRepository
    ):
        self.postgres_repository = postgres_repository

    async def add_task(self, user_id: int, task: str, level: str = '1') -> int:
        task_id = self.postgres_repository.add_task(
            id_user=user_id, task=task, level=level
        )
        if task_id:
            return task_id
        else:
            raise ValidationException('Task could not be added')

    async def update_task(self, task_id: int, task: str, level: str = '1') -> bool:
        update_result = self.postgres_repository.update_task(
            id_task=task_id, task=task, level=level
        )
        if update_result:
            return update_result
        else:
            raise ValidationException('Task cant update(check parametrs)')

    async def delete_task(self, task_id: int) -> bool:
        delete_result = self.postgres_repository.delete_task(id_task=task_id)
        if delete_result:
            return delete_result
        else:
            raise NotFoundException('Task')

    async def get_tasks_by_user_id(self, user_id: int) -> list[TaskResponse]:
        tasks = self.postgres_repository.get_tasks_by_user_id(id_user=user_id)
        grouped_tasks = defaultdict(list)
        grouped_tasks['задачи'] = []
        grouped_tasks['в работе'] = []
        grouped_tasks['выполнено'] = []
        for task in tasks:
            task_response = Task(id=task[0], task=task[1], status=task[2], level=task[3])
            task_status = task_response.status
            grouped_tasks[task_status].append(task_response)

        result = [TaskResponse(status=status, tasks=task_list) for status, task_list in grouped_tasks.items()]
        return result

    async def change_task_status(self, task_id_old: int, task_id_new: int = None) -> bool:
        result = self.postgres_repository.change_task_status(
            id_task_old=task_id_old, id_task_new=task_id_new
        )
        if result:
            return result
        else:
            raise ValidationException('Status could not be changed(check params)')
