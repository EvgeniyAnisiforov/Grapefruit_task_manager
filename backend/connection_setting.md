# Параметры соединения
# (!)name server: grapefruit
# (?)server address: localhost
# (?)port: 5432
# (!)maintenance database: task_manager
# (!)username: ilia
# (!)password: ilia
#
# API базы данных:
#
# 1. РЕГИСТРАЦИЯ
# Вызов: SELECT registration(_login, _hash_passwd, _name, _surname)
# Параметры: строка(<=60) логин, строка(<=60) пароль, строка(<=50) имя, строка(<=50) фамилия
# Возвращаемое значение: boolean. 
# Описание: Вставка в таблицу Users.
#
# 2. АВТОРИЗАЦИЯ
# Вызов: SELECT authorization(_login, _passwd)
# Параметры: строка(<=60) логин, строка(<=60) пароль
# Возвращаемое значение: {id, имя, фамилия} пользователя если найден, возвращается
# none(Python), null(sql).
# Описание: Выборка из таблицы Users по логину и паролю.
#
# 3. КАНБАН доска.
#
# 3.1 ПОЛУЧИТЬ СПИСОК ЗАДАЧ ПОЛЬЗОВАТЕЛЯ
# Вызов: SELECT get_kanban_info(_id_user)
# Параметры: число id
# Возвращаемое значение: множество кортежей, в одном кортеже содержится - id задачи, сама задача, категория(символьно) и сложность задачи('1'-'5'). Или пустой кортеж.
# Описание: Выборка из таблицы Канбан, отсортированная по столбцу ord(порядковый номер), таким образом, чтобы задачи отображались на вебе в тех же позициях, в каких их оставил юзер, нужно соблюдать "очередь"(первый пришел, первый ушел).
#
# 3.2 ДОБАВИТЬ НОВУЮ ЗАДАЧУ
# Вызов: SELECT add_new_task(_id_user, _task, _level = '1')
# Параметры: число id, текст содержимое задачи, символ(1) опциональный параметр уровень сложности
# Возвращаемое значение: id задачи или null
# Описание: Вставка в таблицу Канбан, по триггеру до обновлению вычисляется порядковый номер как Max()+1, соответственно новая задача всегда добавляется в конец категории "задачи".
#
# 3.3 ОБНОВЛЕНИЕ НАЗВАНИЯ/СЛОЖНОСТИ ЗАДАЧИ
# Вызов: update_task(_id_kanban, _task, _level = '1')
# Параметры: число id, текст опционально новое название задачи, символ(1) опционально
# уровень сложности
# Возвращаемое значение: Boolean
# Описание: Уже не такая уж скучная функция
#
# 3.4 УДАЛИТЬ ЗАДАЧУ
# Вызов: delete_task(_id_kanban)
# Параметры: число id
# Возвращаемое значение: Boolean
# Описание: Удаление из таблицы канбан по первичному ключу. После удалению в триггеры обновляется порядковый номер задач, все задачи в одной категории после удаляемой смещаются вверх.
#
# 3.5 ПЕРЕМЕЩЕНИЕ ЗАДАЧИ
# Вызов: replace_task(_id_kanban_old, _id_kanban_new)
# Параметры: первый id - той задачи что перетаскивают, второй id той куда перетаскивают ИЛИ возможны два случая, когда второй id невозможно добыть:
# 1) Перенос в пустую категорию
# 2) Перенос в конец категории(в свободную область под каждой категорией, я полагаю в этом месте тоже нельзя определить ID)
# В этих двух случаях, фронт должен предопределить поведение библиотеки, мне нужно чтобы в этих случаях вторым id мне передалось
# одно из трех предопределенных значений, -1 если в первую категорию, -2 если во вторую и -3 в третью.
# Возвращаемое значение: Boolean
# Описание: небольшой алгоритм, который влияет в основном на сохранность перестановок задач пользователем. Смещает задачки внутри категории/вне категорий, 
# есть проверка "через категория нельзя проскочить", в тех двух случаях без лишних параметров определяет какой случай перед ним.
#
#
#
#
# * можно явно передавать параметры таким образом (parameter => value)
