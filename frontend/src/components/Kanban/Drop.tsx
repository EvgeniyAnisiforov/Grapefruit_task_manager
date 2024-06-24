import { FC, ReactNode } from "react"
import { Droppable } from "react-beautiful-dnd"

interface TasksType {
    id: string;
    text: string;
    rating: number;
}

interface SectionType {
    id: string,
    title: string,
    tasks: TasksType[]
}

interface TypePropsDrop {
    section: SectionType
    children: ReactNode
}

const Drop: FC<TypePropsDrop> = ({ section, children }) => {
  return (
    <Droppable key={section.id} droppableId={section.id}>
      {(provided) => (
        <div
          {...provided.droppableProps}
          ref={provided.innerRef}
          className={`w-[100%] h-full bg-[#ffffff] p-5  ${
            section.title === "Выполнено"
              ? "rounded-tr-3xl rounded-br-3xl border-l-2 border-solid border-black"
              : section.title === "Задачи"
              ? "rounded-tl-3xl rounded-bl-3xl border-r-2 border-solid border-black"
              : ""
          }`}
        >
          <p className="text-3xl border-b-2 border-solid border-black w-52 mr-auto ml-auto pb-2">
            {section.title}
          </p>
          <div className=" w-[100%] max-h-[85%] mt-7 ml-auto mr-auto flex flex-wrap justify-center gap-2.5">
            {children}
            {provided.placeholder}
          </div>
        </div>
      )}
    </Droppable>
  )
}
export default Drop
