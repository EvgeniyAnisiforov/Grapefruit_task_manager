import { FC } from "react"
import { useSortable } from "@dnd-kit/sortable"
import { CSS } from "@dnd-kit/utilities"

interface PropsItemCaptcha {
  id: string
  img: any
  handle: boolean
}

const ItemsCaptcha: FC<PropsItemCaptcha> = ({ id, img }) => {
  const {
    attributes,
    listeners,
    setNodeRef,
    transform,
    transition,
    isDragging,
  } = useSortable({ id: id })

  const style = {
    transform: CSS.Transform.toString(transform),
    transition,
    width: "150px",
    height: "150px",
    margin: "1px",
    zIndex: isDragging ? "100" : "auto",
    opacity: isDragging ? 0.3 : 1,
  }
  return (
    <div ref={setNodeRef} style={style}>
      <img
        {...listeners}
        {...attributes}
        className="w-[150px] h-[150px] m-[1px] border-slate-950 border-[1px] cursor-grab"
        id={id}
        src={img}
      />
    </div>
  )
}

export default ItemsCaptcha
