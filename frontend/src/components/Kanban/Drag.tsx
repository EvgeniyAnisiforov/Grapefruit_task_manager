import { FC, useState } from "react"
import { Draggable } from "react-beautiful-dnd"
import { Pencil } from 'lucide-react';
import { Trash2 } from "lucide-react"
import { FaStar } from "react-icons/fa6";
import { useDeleteDataTaskMutation, useUpdateTaskMutation } from "../../redux/API/KanbanApi";
import WrapperWindowFormAdd from './WrapperWindowFormAdd'


interface Task {
    id: string;
    task: string;
    level: string;
}


interface PropsTypeDrag {
    task: Task
    index: number,
    bg: string
}

const Drag: FC<PropsTypeDrag> = ({ task, index, bg }) => {
  const [visibleModalWindow, setVisibleModalWindow] = useState<boolean>(false);
  const [deleteTask] = useDeleteDataTaskMutation()
  const [updateTask] = useUpdateTaskMutation()
  const handleDelete = () => {
    deleteTask(task.id)
  }
  const editTask = (e: Task) => {
    updateTask({task_id: task.id, task: e.task, level: e.level})
    setVisibleModalWindow(false)
  }

  return (
    <>
      <Draggable key={task.id.toString()} draggableId={task.id.toString()} index={index}>
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
            <div className="flex items-center ml-4">
              <p className="text-lg">{task.level}</p>
              <FaStar className="w-5 h-5 ml-1"/>
            </div>
            {task.task.length <= 75
              ? task.task.substring(0, 1).toUpperCase() + task.task.substring(1)
              : (
                  task.task.substring(0, 1).toUpperCase() + task.task.substring(1)
                ).substring(0, 75) + "..."}
            <div className="flex">
              <Pencil onClick={()=> setVisibleModalWindow(true)}/>
              <Trash2 onClick={handleDelete} className="ml-1 mr-4 cursor-pointer hover:w-7 hover:h-7" />
            </div>
          </div>
        )}
      </Draggable>



      {visibleModalWindow && (
        <WrapperWindowFormAdd onClick={() => setVisibleModalWindow(false)} actionTask={editTask}/>
      )}
    </>
    
  )
}
export default Drag
