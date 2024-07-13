import psycopg2
from contextlib import contextmanager


class PostgresRepository:
    def __init__(
            self,
            database,
            user, password,
            host='localhost',
            port=5432
    ):
        self.database = database
        self.user = user
        self.password = password
        self.host = host
        self.port = port

    @contextmanager
    def connect(self):
        conn = psycopg2.connect(
            dbname=self.database,
            user=self.user,
            password=self.password,
            host=self.host,
            port=self.port
        )
        try:
            yield conn
        finally:
            conn.close()

    def create_user(self, login, passwd, name, surname):
        with self.connect() as conn:
            with conn.cursor() as cur:
                cur.execute(
                    "SELECT public.registration(%s, %s, %s, %s);",
                    (login, passwd, name, surname)
                )
                conn.commit()
                user_info = cur.fetchone()[0]
                return user_info

    def authorize(self, login: str, passwd: str):
        with self.connect() as conn:
            with conn.cursor() as cur:
                cur.execute(
                    "SELECT * FROM public.authorization(%s, %s);",
                    (login, passwd)
                )
                user_info = cur.fetchone()
                return user_info

    def add_task(self, id_user, task: str, level='1'):
        with self.connect() as conn:
            with conn.cursor() as cur:
                cur.execute(
                    "SELECT public.add_new_task(%s, %s, %s);",
                    (id_user, task, level)
                )
                task_id = cur.fetchone()[0]
                conn.commit()
                return task_id

    def update_task(self, id_task, task: str, level='1'):
        with self.connect() as conn:
            with conn.cursor() as cur:
                cur.execute(
                    "SELECT public.update_task(%s, %s, %s);",
                    (id_task, task, level)
                )
                conn.commit()
                bool_resp = cur.fetchone()[0]
                return bool_resp

    def delete_task(self, id_task):
        with self.connect() as conn:
            with conn.cursor() as cur:
                cur.execute(
                    "SELECT * FROM public.delete_task(%s);",
                    (id_task,)
                )
                conn.commit()
                tasks = cur.fetchone()[0]
                return tasks

    def get_tasks_by_user_id(self, id_user):
        with self.connect() as conn:
            with conn.cursor() as cur:
                cur.execute(
                    "SELECT * FROM public.get_kanban_info(%s);",
                    (id_user,)
                )
                tasks = cur.fetchall()
                return tasks

    def change_task_status(self, id_task_old, id_task_new=None):
        with self.connect() as conn:
            with conn.cursor() as cur:
                cur.execute(
                    "SELECT public.replace_task(%s, %s);",
                    (id_task_old, id_task_new)
                )
                result = cur.fetchone()[0]
                conn.commit()
                return result
