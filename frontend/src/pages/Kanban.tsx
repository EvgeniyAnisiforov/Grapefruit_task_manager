import { FC, useState } from "react"
import HeaderPages from "../components/HeaderPages"
import { SquarePlus } from "lucide-react"
import Drop from "../components/Kanban/Drop"
import Drag from "../components/Kanban/Drag"
import DragEndHandler from "../components/Kanban/DragEndHandler"
import { useGetDataKanbanQuery } from "../redux/API/KanbanApi"
import { useAddDataTaskMutation } from "../redux/API/KanbanApi"
import { useAppSelector } from "../redux/hook"
import WrapperWindowFormAdd from "../components/Kanban/WrapperWindowFormAdd"


type Task = {
  id: string
  task: string
  level: string
}

type Section = {
  status: string
  tasks: Task[]
}

const Kanban: FC<{}> = () => {
  const [visibleModalWindow, setVisibleModalWindow] = useState<boolean>(false);
  
  const id = useAppSelector((status) => status.statusAuth.value.id);
  const [addDataTask] = useAddDataTaskMutation()
  const { data = [] } = useGetDataKanbanQuery(id);

  const addTask = (e: Task) => {
    addDataTask({user_id: e.id, task: e.task, level: e.level})
    setVisibleModalWindow(false)
   }
  return (
    <>
      <HeaderPages>
        <div className="flex justify-center items-center h-[70%] m-10">
          <div className="w-[95%] h-full flex justify-center ml-auto mr-auto">
            <DragEndHandler data={data}>
              {data.map((section: Section) => (
                <Drop key={section.status} section={section}>
                  {section.tasks.map((task, index) => (
                    <Drag
                      key={task.id.toString()}
                      task={task}
                      index={index}
                      bg={
                        section.status === "задачи"
                          ? "bg-[#fb5656]"
                          : section.status === "в работе"
                          ? "bg-[#eff75f]"
                          : section.status === "выполнено"
                          ? "bg-[#95fb56]"
                          : ""
                      }
                    ></Drag>
                  ))}
                </Drop>
              ))}
            </DragEndHandler>
          </div>
        </div>

        <div className="flex justify-center">
          <SquarePlus
            onClick={() => setVisibleModalWindow(true)}
            className="text-white w-16 h-16 mt-3 cursor-pointer"
          />
        </div>
      </HeaderPages>

      {visibleModalWindow && (
        <WrapperWindowFormAdd onClick={() => setVisibleModalWindow(false)} actionTask={addTask}/>
      )}
    </>
  )
}
export { Kanban }
