from typing import List

from app.db.PostgresRepository import PostgresRepository
from app.exceptions.exceptions import NotFoundException, ValidationException
from app.models.kanban import TaskResponse


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

    async def get_tasks_by_user_id(self, user_id: int) -> List[TaskResponse]:
        tasks = self.postgres_repository.get_tasks_by_user_id(id_user=user_id)
        if tasks:
            return [TaskResponse(id=task[0], task=task[1], status=task[2], level=task[3]) for task in tasks]
        else:
            raise NotFoundException('Tasks')

    async def update_task_order(self, task_id_old: int, task_id_new: int) -> bool:
        result = self.postgres_repository.update_task_ord(
            id_task_old=task_id_old, id_task_new=task_id_new
        )
        if result:
            return result
        else:
            raise ValidationException('Order could not be updated(check params)')

    async def change_task_status(self, task_id_old: int, task_id_new: int = None) -> bool:
        result = self.postgres_repository.change_task_status(
            id_task_old=task_id_old, id_task_new=task_id_new
        )
        if result:
            return result
        else:
            raise ValidationException('Status could not be changed(check params)')

