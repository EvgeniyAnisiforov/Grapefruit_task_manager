import {FC} from 'react'
import { useAppSelector } from '../../redux/hook'
import {useLocation, Navigate} from 'react-router-dom'

interface PropsRequireAuth {
    children: React.ReactNode
}

const RequireAuth: FC<PropsRequireAuth> = ({children}) => {
    const location = useLocation()
    const auth = useAppSelector((state) => state.statusAuth.value.status)

    if(!auth){
        return <Navigate to='/' state={{from: location}}/>
    }

    return children
}
export default RequireAuth