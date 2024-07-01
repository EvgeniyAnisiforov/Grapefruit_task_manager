import psycopg2
from contextlib import contextmanager


class Database:
    def __init__(self, database, user, password, host='localhost', port=5432):
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

    def update_task_ord(self, id_task_old, id_task_new):
        with self.connect() as conn:
            with conn.cursor() as cur:
                cur.execute(
                    "SELECT public.func_update_kanban_ord(%s, %s);",
                    (id_task_old, id_task_new)
                )
                conn.commit()
                result = cur.fetchone()[0]
                return result

    def change_task_category(self, id_task_old, id_task_new=None):
        with self.connect() as conn:
            with conn.cursor() as cur:
                cur.execute(
                    "SELECT public.func_change_category(%s, %s);",
                    (id_task_old, id_task_new)
                )
                result = cur.fetchone()[0]
                conn.commit()
                return result


# Пример использования
if __name__ == "__main__":
    db = Database(database="grapefruit", user="postgres", password="admin", host='localhost', port=5432)

    # # Регистрация нового пользователя
    # print(db.create_user("new_user", "hashed_password", "John", "Doe"))

    # Добавление новой задачи
    # task_id = db.add_task(id_user=5, task="Новая задача", level='2')
    # print(f"Task added with ID: {task_id}")
    #
    # Обновление задачи
    # print(db.update_task(id_task=32, task="Обновленная задачаd", level='3'))
    #
    # # Получение информации по задачам пользователя
    # kanban_info = db.get_kanban_info(id_user=5)
    # print("Kanban info:", kanban_info)

    # result = db.change_category(id_kanban_old=, id_kanban_new=20)
    # print(f"Update Kanban Ord result: {result}")
    #
    # # # # Удаление задачи
    # print(db.delete_task(37))

    user_info = db.authorize("ilia", "python")
    print(user_info)
