import { DragDropContext, DropResult } from "react-beautiful-dnd"
import { FC } from "react"
import { useChangeStatusMutation } from "../../redux/API/KanbanApi"

type Task = {
  id: string
  task: string
  level: string
}

type Section = {
  status: string
  tasks: Task[]
}

interface DragEndHandlerProps {
  data: Section[]
  children: React.ReactNode
}

const DragEndHandler: FC<DragEndHandlerProps> = ({
  data,
  children,
}) => {

  const [change_status] = useChangeStatusMutation()

  const onDragEnd = (result: DropResult) => {
    if (!result.destination) return
    const { source, destination } = result

    if (source.droppableId !== destination.droppableId) {
      const sourceColIndex = data.findIndex(
        (e) => e.status === source.droppableId
      )
      const destinationColIndex = data.findIndex(
        (e) => e.status === destination.droppableId
      )

      const sourceCol = data[sourceColIndex]
      const destinationCol = data[destinationColIndex]

      const destinationTasks = [...destinationCol.tasks]
      
      if(destinationTasks.length === destination.index || destinationCol.tasks.length == 0){
        if(destinationCol.status == 'задачи'){
          change_status({task_id_old: sourceCol.tasks[source.index].id, task_id_new: -1})
          return
        }
        if(destinationCol.status == 'в работе'){
          change_status({task_id_old: sourceCol.tasks[source.index].id, task_id_new: -2})
          return
        }
        if(destinationCol.status == 'выполнено'){
          change_status({task_id_old: sourceCol.tasks[source.index].id, task_id_new: -3})
          return
        }
      }
      
      change_status({task_id_old: sourceCol.tasks[source.index].id, task_id_new: destinationTasks[destination.index].id})
    }
  }

  return <DragDropContext onDragEnd={onDragEnd}>{children}</DragDropContext>
}

export default DragEndHandler
