import { FC, useState } from "react"
import HeaderPages from "../components/HeaderPages"
import { SquarePlus } from "lucide-react"
import { Input } from "antd"
import ModalWindow from "../components/ModalWindow"
import TaskRatingInput from "../components/Kanban/TaskRatingInput"
import { DragDropContext, } from "react-beautiful-dnd"
import { v4 as uuidv4 } from "uuid"
import Drop from "../components/Kanban/Drop"
import Drag from "../components/Kanban/Drag"

const mockData = [
  {
    id: uuidv4(),
    title: "Задачи",
    tasks: [
      {
        id: uuidv4(),
        text: "aaa",
        rating: 1,
      },
      {
        id: uuidv4(),
        text: "aaa",
        rating: 2,
      },
      {
        id: uuidv4(),
        text: "aaa",
        rating: 5,
      },
    ],
  },
  {
    id: uuidv4(),
    title: "В работе",
    tasks: [
      {
        id: uuidv4(),
        text: "aaa",
        rating: 1,
      },
      {
        id: uuidv4(),
        text: "aaa",
        rating: 2,
      },
      {
        id: uuidv4(),
        text: "aaa",
        rating: 5,
      },
    ],
  },
  {
    id: uuidv4(),
    title: "Выполнено",
    tasks: [
      {
        id: uuidv4(),
        text: "aaa",
        rating: 1,
      },
      {
        id: uuidv4(),
        text: "aaa",
        rating: 2,
      },
      {
        id: uuidv4(),
        text: "aaa",
        rating: 5,
      },
    ],
  },
]
const Kanban: FC<{}> = () => {
  const [visibleModalWindow, setVisibleModalWindow] = useState<boolean>(false)
  const [data, setData] = useState(mockData)

  const onDragEnd = (result:any) => {
    if (!result.destination) return;
    const { source, destination } = result;
  
    if (source.droppableId !== destination.droppableId) {
      const sourceColIndex = data.findIndex(e => e.id === source.droppableId);
      const destinationColIndex = data.findIndex(e => e.id === destination.droppableId);
  
      const sourceCol = data[sourceColIndex];
      const destinationCol = data[destinationColIndex];
  
      const sourceTasks = [...sourceCol.tasks];
      const destinationTasks = [...destinationCol.tasks];
  
      const [removed] = sourceTasks.splice(source.index, 1);
      destinationTasks.splice(destination.index, 0, removed);
  
      const newData = data.map(col => {
        if (col.id === source.droppableId) {
          return { ...col, tasks: sourceTasks };
        } else if (col.id === destination.droppableId) {
          return { ...col, tasks: destinationTasks };
        }
        return col;
      });
  
      setData(newData);
    }
  };

  return (
    <>
      <HeaderPages>
        <div className="flex justify-center items-center h-[70%] m-10">
          <div className="w-[95%] h-full flex justify-center ml-auto mr-auto">
            <DragDropContext onDragEnd={onDragEnd}>
              {data.map((section) => (
                <Drop section={section}>
                  {section.tasks.map((task, index) => (
                    <Drag
                      task={task}
                      index={index}
                      bg={
                        section.title === "Задачи"
                          ? "bg-[#fb5656]"
                          : section.title === "В работе"
                          ? "bg-[#eff75f]"
                          : section.title === "Выполнено"
                          ? "bg-[#95fb56]"
                          : ""
                      }
                    ></Drag>
                  ))}
                  
                </Drop>
              ))}
            </DragDropContext>
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
        <ModalWindow
          onClick={() => setVisibleModalWindow(false)}
          width="w-[400px]"
          height="h-[400px]"
          items="items-start"
        >
          <div className="mt-28">
            <Input
              placeholder="Название задачи"
              className="w-[300px] h-[40px] mb-3 text-xl"
            />
            <TaskRatingInput />
            <button className="absolute bottom-10 left-1/4 right-1/4 bg-green-500 hover:bg-green-600 rounded-xl mt-5 px-3 py-1.5 text-white text-2xl shadow-[0_0_10px_rgb(74_222_128)] transition duration-300 ease-in-out focus:outline-none">
              Добавить
            </button>
          </div>
        </ModalWindow>
      )}
    </>
  )
}
export { Kanban }
