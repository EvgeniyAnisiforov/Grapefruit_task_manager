import { FC, useState } from "react"
import { Controller } from "react-hook-form"
import { Menu, MenuProps } from "antd"

type MenuItem = Required<MenuProps>["items"][number]

const items: MenuItem[] = [
  {
    key: "sub4",
    label: 'Рейтинг сложности',
    style: {
      fontSize: "1.3em",
      lineHeight: "35px", // Установите высоту строки, соответствующую высоте меню
      width: '90%',
    },
    children: [
      {
        key: 1,
        label: "1★",
        style: {
          height: "28px",
          display: "flex",
          justifyContent: "center",
          alignItems: "center",
        },
      },
      {
        key: 2,
        label: "2★",
        style: {
          height: "28px",
          display: "flex",
          justifyContent: "center",
          alignItems: "center",
        },
      },
      {
        key: 3,
        label: "3★",
        style: {
          height: "28px",
          display: "flex",
          justifyContent: "center",
          alignItems: "center",
        },
      },
      {
        key: 4,
        label: "4★",
        style: {
          height: "28px",
          display: "flex",
          justifyContent: "center",
          alignItems: "center",
        },
      },
      {
        key: 5,
        label: "5★",
        style: {
          height: "28px",
          display: "flex",
          justifyContent: "center",
          alignItems: "center",
        },
      },
    ],
  },
]

const TaskRatingInput: FC<{ control: any; name: string; errors: any }> = ({
  control,
  name,
  errors
}) => {
  const [rating, setRating] = useState<string>("1")

  const onClick = (e: any) => {
    setRating(e.key)
  }

  return (
    <>
    <Controller
      control={control}
      name={name}
      rules={{ required: "Необходимо выбрать рейтинг задачи" }}
      render={({ field }) => (
        <Menu
          onClick={(e) => {
            onClick(e)
            field.onChange(e.key)
          }}
          selectedKeys={[rating]}
          mode="horizontal"
          items={items}
          style={{
            margin: "0 auto",
            display: "flex",
            alignItems: "center", // Это гарантирует, что текст будет по центру по вертикали
            justifyContent: "center",
          }}
        />
      )}
    />
    {errors.taskRating && (
      <p className="text-red-500">{errors.taskRating.message}</p>
    )}</>
  )
}

export default TaskRatingInput
