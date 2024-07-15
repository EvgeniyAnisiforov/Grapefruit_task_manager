import { FC, useEffect, useState } from "react"
import {
  DndContext,
  closestCenter,
  KeyboardSensor,
  PointerSensor,
  useSensor,
  useSensors,
  DragOverlay,
} from "@dnd-kit/core"
import {
  arrayMove,
  SortableContext,
  sortableKeyboardCoordinates,
  rectSortingStrategy,
} from "@dnd-kit/sortable"
import ItemsCaptcha from "./ItemsCaptcha"
import {
  useGetCaptchaQuery,
  usePostCaptchaMutation,
} from "../../redux/API/CaptchaApi"


type TypeItemsCaptcha = {
  id: string
  img: string
}

interface PropsTypeWrapperCaptcha {
  closeCaptcha: () => void
  victoryCaptcha: ()=> void
}

const WrapperCaptcha: FC<PropsTypeWrapperCaptcha> = ({closeCaptcha, victoryCaptcha}) => {
  const [activeId, setActiveId] = useState(null)
  const [activeImg, setActiveImg] = useState<string | null>(null)

  const [items, setItems] = useState<TypeItemsCaptcha[]>([])
  const { data = [] } = useGetCaptchaQuery([])
  const [strIdCaptcha] = usePostCaptchaMutation()
  useEffect(() => {
    if (data) {
      setItems(data)
    }
  }, [data])

  const sensors = useSensors(
    useSensor(PointerSensor),
    useSensor(KeyboardSensor, {
      coordinateGetter: sortableKeyboardCoordinates,
    })
  )

  const handleDragStart = (event: any) => {
    setActiveId(event.active.id)
    const img = items.filter((el) => el.id === event.active.id)
    setActiveImg(img[0].img)
  }

  const handleDragEnd = (event: any) => {
    setActiveId(null)
    const { active, over } = event

    if (active.id !== over.id) {
      setItems((items) => {
        const oldIndex = items.findIndex((el) => el.id === active.id)
        const newIndex = items.findIndex((el) => el.id === over.id)

        return arrayMove(items, oldIndex, newIndex)
      })
    }
  }

  const handleClick = () => {
    const str = items
      .map((el) => el.id)
      .reduce((acc, current) => acc + current, "")
    console.log(str)
    strIdCaptcha({ captcha_code: str }).then((result) => {
      console.log(result.data) // Доступ к данным ответа
      if(result.data === true){
        closeCaptcha()
        victoryCaptcha()
      }
    })
  }

  return (
    <DndContext
      sensors={sensors}
      collisionDetection={closestCenter}
      onDragEnd={handleDragEnd}
      onDragStart={handleDragStart}
    >
      <div className="absolute top-14 left-1/4 right-1/4">
        <h1 className="text-2xl">Собери рисунок грейфрута</h1>
      </div>

      <div className="w-[460px] h-[460px] flex flex-wrap border-slate-700 border-[1px]">
        <SortableContext items={items} strategy={rectSortingStrategy}>
          {items.map((el) => (
            <ItemsCaptcha key={el.id} id={el.id} img={el.img} handle={true} />
          ))}
          <DragOverlay>
            {activeId ? (
              <div className="w-[150px] h-[150px] cursor-grabbing">
                <ItemsCaptcha
                  key={activeId}
                  id={activeId}
                  img={activeImg}
                  handle={true}
                />
              </div>
            ) : null}
          </DragOverlay>
        </SortableContext>
      </div>

      <button
        onClick={handleClick}
        className="absolute bottom-10 left-1/4 right-1/4 bg-green-500 hover:bg-green-600 rounded-xl px-5 py-1.5 text-white text-2xl shadow-[0_0_10px_rgb(74_222_128)] transition duration-300 ease-in-out focus:outline-none"
      >
        Отправить
      </button>
    </DndContext>
  )
}
export default WrapperCaptcha
