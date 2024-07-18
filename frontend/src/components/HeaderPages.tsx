import {FC, ReactNode} from "react"
import { AlignJustify } from 'lucide-react';
import { Settings } from 'lucide-react';
import { useAppDispatch, useAppSelector } from "../redux/hook";
import { LogOut } from 'lucide-react';
import { setStatusAuth } from "../redux/statusAuth-slice";
interface PropsType {
    children: ReactNode
}

const HeaderPages: FC<PropsType> = ({children}) => {
    const dispatch = useAppDispatch()
    const nameUser = useAppSelector(state => state.statusAuth.value)
    return (
        <div className="w-screen h-screen">
            <div className="w-full h-full bg-gradient-to-l from-red-500 to-orange-500">
            <div className='flex items-center justify-between'>
                <div className='flex p-5 pl-7'>
                    <div className='p-1'><AlignJustify className='text-white w-10 h-10'/></div>
                    <div className='p-1'><Settings className='text-white w-10 h-10'/></div>
                </div>
                <div className='flex items-center pr-7'>
                    <h2 className='text-white text-2xl'>{(nameUser.surname[0].toUpperCase() + nameUser.surname.slice(1)) + ' ' + (nameUser.name[0].toUpperCase() + nameUser.name.slice(1))}</h2>
                    <LogOut onClick={()=>dispatch(setStatusAuth({ status: false, id: '', name: '', surname: '' }))} className="ml-5 w-8 h-8 text-white cursor-pointer hover:h-9 hover:w-9"/>
                </div>
            </div>
            {children}
            </div>
        </div>
    )
}
export default HeaderPages