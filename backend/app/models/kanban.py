from pydantic import BaseModel
from typing_extensions import List


class TaskRequest(BaseModel):
    user_id: int
    task: str
    level: str = '1'


class TaskUpdateRequest(BaseModel):
    task_id: int
    task: str
    level: str = '1'


class Task(BaseModel):
    id: int
    task: str
    status: str
    level: str


class TaskResponse(BaseModel):
    status: str
    tasks: List[Task]


class TaskUpdateStatusChangeRequest(BaseModel):
    task_id_old: int
    task_id_new: int

