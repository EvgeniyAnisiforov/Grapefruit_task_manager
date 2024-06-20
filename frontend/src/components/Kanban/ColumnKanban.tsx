import {FC, ReactNode} from 'react'

interface PropsTypeColumnKanban {
    children: ReactNode
    title: string
}


const ColumnKanban: FC<PropsTypeColumnKanban> = ({children, title }) => {
    return (
        <div
          className={`w-1/3 h-full bg-[#ffffff] p-5  ${
            title === 'Выполнено' ? 'rounded-tr-3xl rounded-br-3xl border-l-2 border-solid border-black' : title === 'Задачи' ?  'rounded-tl-3xl rounded-bl-3xl border-r-2 border-solid border-black' : ''
          }`}
        >
          <p className='text-3xl border-b-2 border-solid border-black w-52 mr-auto ml-auto pb-2'>
            {title}
          </p>
          <div className=' w-[100%] max-h-[85%] mt-7 ml-auto mr-auto flex flex-wrap justify-center gap-2.5'>
            {children}
          </div>
        </div>
      );
}
export default ColumnKanban
 