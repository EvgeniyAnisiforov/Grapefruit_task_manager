import {FC, ReactNode} from 'react'
import { X } from 'lucide-react';

interface PropsType {
    children: ReactNode
    onClick: () => void
    width: string,
    height: string,
    items: string
}

const ModalWindow: FC<PropsType> = ({children, onClick, width = 'w-[500px]', height = 'h-[700px]', items = 'items-center'}) => {
    return (
        <div onClick={()=>onClick()} className='bg-[rgba(0,0,0,.5)] w-full h-full fixed top-0 right-0 left-0 bottom-0 flex justify-center items-center backdrop-blur-sm transition-opacity duration-500 ease-in-out opacity-100 cursor-pointer'>
            <div onClick={(e)=> e.stopPropagation()} className={`bg-white z-10 rounded-3xl shadow-[0_0_10px_rgb(255,255,255)] flex justify-center ${items} relative cursor-default ${width} ${height}`}>
                <X onClick={()=>onClick()} className='absolute top-3 right-3 w-10 h-10 cursor-pointer'/>
                {children}
            </div>
        </div>
    )
}

export default ModalWindow