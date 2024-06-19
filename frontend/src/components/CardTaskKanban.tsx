import {FC} from 'react'
import { Trash2 } from 'lucide-react';
import { Star } from 'lucide-react';

interface PropsType {
    reting: number
    text: string,
    bg?: string
}

const CardTaskKanban: FC<PropsType> = ({reting, text, bg}) => {
    return (
        <div className={`w-[100%] h-[70px] ${bg} rounded-xl flex justify-between items-center`}>
            <div className='flex items-center ml-2'><p className='text-lg'>{reting}</p><Star className='w-5 h-5'/></div>
            {text.length <= 75 
            ? text.substring(0, 1).toUpperCase() + text.substring(1)
            : (text.substring(0, 1).toUpperCase() + text.substring(1)).substring(0, 75) + "..."}
            <Trash2 className='mr-2'/>
        </div>
    )
}
export default CardTaskKanban