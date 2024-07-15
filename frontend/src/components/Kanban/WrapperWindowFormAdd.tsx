import { FC } from "react"
import ModalWindow from "../ModalWindow"
import FormAdd from "./FormAdd"

type Task = {
    id: string
    task: string
    level: string
  }

interface PropsWrapperWindowFormAdd  {
    actionTask: (e:Task) => void,
    onClick: ()=> void
}

const WrapperWindowFormAdd: FC<PropsWrapperWindowFormAdd> = ({actionTask, onClick}) => {
  return (
    <>
        <ModalWindow
          onClick={()=>onClick()}
          width="w-[400px]"
          height="h-[400px]"
          items="items-start"
        >
          <FormAdd actionTask={actionTask} />
        </ModalWindow>
    </>
  )
}
export default WrapperWindowFormAdd
