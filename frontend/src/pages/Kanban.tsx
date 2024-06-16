import {FC, useState} from 'react'
import HeaderPages from '../components/HeaderPages'
import { SquarePlus } from 'lucide-react';
import { Input } from "antd"
import ModalWindow from '../components/ModalWindow';
import TaskRatingInput from '../components/TaskRatingInput';
import CardTaskKanban from '../components/CardTaskKanban';


const Kanban: FC<{}> = () => {

  const [visibleModalWindow, setVisibleModalWindow] = useState<boolean>(false)
    return (
      <>
        <HeaderPages>
          <div className='flex justify-center items-center h-[70%] m-10'>
            <div className='w-[95%] h-full flex justify-center ml-auto mr-auto'>
              <div className='w-1/3 h-full bg-[#ffffff] p-5 rounded-tl-3xl rounded-bl-3xl border-r-2 border-solid border-black'>
                <p className='text-3xl border-b-2 border-solid border-black w-52 mr-auto ml-auto pb-2'>
                  Задачи
                </p>
                <div className=' w-[100%] max-h-[85%] mt-7 ml-auto mr-auto flex flex-wrap justify-center gap-2.5'>
                  <CardTaskKanban text='Сделать лабы по асип' bg='bg-[#fb5656]' reting={1}/>
                  <CardTaskKanban text='Нарисовать схему' bg='bg-[#fb5656]' reting={2}/>
                  <CardTaskKanban text='Покушать' bg='bg-[#fb5656]' reting={5}/>
                </div>
              </div>
              <div className='w-1/3 h-full bg-[#ffffff] p-5 border-r-2 border-solid border-black'>
                <p className='text-3xl border-b-2 border-solid border-black w-52 mr-auto ml-auto pb-2'>
                  В работе
                </p>
                <div className=' w-[100%] max-h-[85%] mt-7 ml-auto mr-auto flex flex-wrap justify-center gap-2.5'>
                  <CardTaskKanban text='Сделать лабы по асип' bg='bg-[#eff75f]' reting={1}/>
                  <CardTaskKanban text='Нарисовать схему' bg='bg-[#eff75f]' reting={2}/>
                  <CardTaskKanban text='Покушать' bg='bg-[#eff75f]' reting={5}/>
                </div>
              </div>
              <div className='w-1/3 h-full bg-[#ffffff] p-5 rounded-tr-3xl rounded-br-3xl'>
                <p className='text-3xl border-b-2 border-solid border-black w-52 mr-auto ml-auto pb-2'>
                  Выполнено
                </p>
                <div className=' w-[100%] max-h-[85%] mt-7 ml-auto mr-auto flex flex-wrap justify-center gap-2.5'>
                  <CardTaskKanban text='Сделать лабы по асип' bg='bg-[#95fb56]' reting={1}/>
                  <CardTaskKanban text='Нарисовать схему' bg='bg-[#95fb56]' reting={2}/>
                  <CardTaskKanban text='Покушать' bg='bg-[#95fb56]' reting={5}/>
                </div>
              </div>
            </div>
          </div>
          <div className='flex justify-center'><SquarePlus onClick={()=> setVisibleModalWindow(true)} className='text-white w-16 h-16 mt-3 cursor-pointer'/></div>
        </HeaderPages>      
        {visibleModalWindow && 
          <ModalWindow onClick={() => setVisibleModalWindow(false)} width='w-[400px]' height='h-[400px]' items='items-start'>
            <div className='mt-28'>
              <Input placeholder='Название задачи' className='w-[300px] h-[40px] mb-3 text-xl'/>
              <TaskRatingInput/>
              <button className="absolute bottom-10 left-1/4 right-1/4 bg-green-500 hover:bg-green-600 rounded-xl mt-5 px-3 py-1.5 text-white text-2xl shadow-[0_0_10px_rgb(74_222_128)] transition duration-300 ease-in-out focus:outline-none">Добавить</button>
            </div>
          </ModalWindow>} 
      </>
  )
}
export {Kanban}