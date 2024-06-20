import {FC, useState} from 'react'
import HeaderPages from '../components/HeaderPages'
import { SquarePlus } from 'lucide-react';
import { Input } from "antd"
import ModalWindow from '../components/ModalWindow';
import TaskRatingInput from '../components/Kanban/TaskRatingInput';
import CardTaskKanban from '../components/Kanban/CardTaskKanban';
import ColumnKanban from '../components/Kanban/ColumnKanban';


const Kanban: FC<{}> = () => {

  const [visibleModalWindow, setVisibleModalWindow] = useState<boolean>(false)
    return (
      <>
        <HeaderPages>
          <div className='flex justify-center items-center h-[70%] m-10'>
            <div className='w-[95%] h-full flex justify-center ml-auto mr-auto'>
              <ColumnKanban title='Задачи'>
                <CardTaskKanban text='ааа' reting={1} bg='bg-[#fb5656]'/>
                <CardTaskKanban text='ааа' reting={2} bg='bg-[#fb5656]'/>
                <CardTaskKanban text='ааа' reting={5} bg='bg-[#fb5656]'/>
              </ColumnKanban>
              <ColumnKanban title='В работе'>
                <CardTaskKanban text='ааа' reting={1} bg='bg-[#eff75f]'/>
                <CardTaskKanban text='ааа' reting={2} bg='bg-[#eff75f]'/>
                <CardTaskKanban text='ааа' reting={5} bg='bg-[#eff75f]'/>
              </ColumnKanban>
              <ColumnKanban title='Выполнено'>
                <CardTaskKanban text='ааа' reting={1} bg='bg-[#95fb56]'/>
                <CardTaskKanban text='ааа' reting={2} bg='bg-[#95fb56]'/>
                <CardTaskKanban text='ааа' reting={5} bg='bg-[#95fb56]'/>
              </ColumnKanban>
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