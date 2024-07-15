import { FC } from "react"
import {Controller} from 'react-hook-form'
import { Input } from "antd"

interface PropsInputValidation {
    control: any,
    errors: any,
    nameTask: string,
    message: string,
    style: string
}

const InputValidation: FC<PropsInputValidation> = ({control, errors, nameTask, message, style}) => {
  return (
    <>
      <Controller
        name={nameTask}
        control={control}
        rules={{
          required: `Поле ${message.toLowerCase()} обязательно для заполнения`,
          maxLength: {
            value: 50,
            message: "Максимальное количество символов - 50",
          },
        }}
        render={({ field }) => (
          <Input
            {...field}
            placeholder={message}
            className={style}
          />
        )}
      />
      {errors.nameTask && typeof errors.nameTask.message === "string" && (
        <p className="text-red-500">{errors.nameTask.message}</p>
      )}
    </>
  )
}
export default InputValidation
