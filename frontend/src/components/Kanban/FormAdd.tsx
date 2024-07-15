import { FC } from "react"
import TaskRatingInput from "../../components/Kanban/TaskRatingInput"
import { useForm, SubmitHandler } from "react-hook-form"
import { useAppSelector } from "../../redux/hook"
import InputValidation from "../InputValidation"

type Task = {
  id: string
  task: string
  level: string
}

interface PropsTypeFromAdd {
  actionTask: (e: Task) => void
}

type SubmitData = {
  nameTask: string
  taskRating: string
}

const FormAdd: FC<PropsTypeFromAdd> = ({ actionTask }) => {
  const {
    control,
    formState: { errors },
    handleSubmit,
  } = useForm<SubmitData>()

  const id = useAppSelector((status) => status.statusAuth.value.id)

  const onSubmit: SubmitHandler<SubmitData> = (data) => {
    actionTask({ id: id, task: data.nameTask, level: data.taskRating })
  }

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="mt-28">
      <InputValidation control={control} errors={errors} nameTask="nameTask" message="Название задачи" style={`w-[300px] h-[40px] mb-3 text-xl ${
              errors.nameTask ? "border-red-500" : ""
            }`}/>
      <TaskRatingInput control={control} name="taskRating" errors={errors} />

      <button
        type="submit"
        className="absolute bottom-10 left-1/4 right-1/4 bg-green-500 hover:bg-green-600 rounded-xl mt-5 px-3 py-1.5 text-white text-2xl shadow-[0_0_10px_rgb(74_222_128)] transition duration-300 ease-in-out focus:outline-none"
      >
        Добавить
      </button>
    </form>
  )
}
export default FormAdd
