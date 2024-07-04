import {FC, ReactNode} from "react"
import { AlignJustify } from 'lucide-react';
import { Settings } from 'lucide-react';
import { useAppSelector } from "../redux/hook";

interface PropsType {
    children: ReactNode
}

const HeaderPages: FC<PropsType> = ({children}) => {
    const nameUser = useAppSelector(state => state.statusAuth.value)
    return (
        <div className="w-screen h-screen">
            <div className="w-full h-full bg-gradient-to-l from-red-500 to-orange-500">
            <div className='flex items-center justify-between'>
                <div className='flex p-5 pl-7'>
                <div className='p-1'><AlignJustify className='text-white w-10 h-10'/></div>
                <div className='p-1'><Settings className='text-white w-10 h-10'/></div>
                </div>
                <h2 className='text-white text-2xl pr-7'>{nameUser.surname + ' ' + nameUser.name}</h2>
            </div>
            {children}
            </div>
        </div>
    )
}
export default HeaderPages