import { FC } from "react"
import { Draggable } from "react-beautiful-dnd"
import { Trash2 } from "lucide-react"
import { Star } from "lucide-react"

interface TasksType {
    id: string;
    text: string;
    rating: number;
}


interface PropsTypeDrag {
    task: TasksType
    index: number,
    bg: string
}

const Drag: FC<PropsTypeDrag> = ({ task, index, bg }) => {
  return (
    <Draggable key={task.id} draggableId={task.id} index={index}>
      {(provided, snapshot) => (
        <div
          ref={provided.innerRef}
          {...provided.draggableProps}
          {...provided.dragHandleProps}
          style={{
            ...provided.draggableProps.style,
            opacity: snapshot.isDragging ? "0.5" : "1",
          }}
          className={`w-[100%] h-[70px] ${bg} rounded-xl flex justify-between items-center  cursor-grab`}
        >
          <div className="flex items-center ml-2">
            <p className="text-lg">{task.rating}</p>
            <Star className="w-5 h-5" />
          </div>
          {task.text.length <= 75
            ? task.text.substring(0, 1).toUpperCase() + task.text.substring(1)
            : (
                task.text.substring(0, 1).toUpperCase() + task.text.substring(1)
              ).substring(0, 75) + "..."}
          <Trash2 className="mr-2" />
        </div>
      )}
    </Draggable>
  )
}
export default Drag
