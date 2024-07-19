import { FC } from "react"
import type { MenuProps } from "antd"
import { Dropdown, Space } from "antd"
import { Settings } from "lucide-react"
import { useAppDispatch } from "../redux/hook"
import { setThemeColor } from "../redux/themeColor-slice"

const MenuColor: FC<{}> = () => {
  const items: MenuProps["items"] = [
    {
      label: (
        <div className="w-[40px] h-[40px] rounded-[50%] bg-gradient-to-r from-orange-400 to-red-500"></div>
      ),
      key: "bg-gradient-to-r from-orange-400 to-red-500",
    },
    {
      label: (
        <div className="w-[40px] h-[40px] rounded-[50%] bg-gradient-to-r from-purple-500 to-pink-300"></div>
      ),
      key: "bg-gradient-to-r from-purple-500 to-pink-300",
    },
    {
      label: (
        <div className="w-[40px] h-[40px] rounded-[50%] bg-gradient-to-r from-cyan-500 to-green-500"></div>
      ),
      key: "bg-gradient-to-r from-cyan-500 to-green-500",
    },
    {
      label: (
        <div className="w-[40px] h-[40px] rounded-[50%] bg-gradient-to-r from-purple-700 to-indigo-600"></div>
      ),
      key: "bg-gradient-to-r from-purple-700 to-indigo-600",
    },
    {
      label: (
        <div className="w-[40px] h-[40px] rounded-[50%] bg-gradient-to-r from-yellow-400 to-orange-500"></div>
      ),
      key: "bg-gradient-to-r from-yellow-400 to-orange-500",
    },
    {
      label: (
        <div className="w-[40px] h-[40px] rounded-[50%] bg-gradient-to-r from-emerald-400 to-lime-300"></div>
      ),
      key: "bg-gradient-to-r from-emerald-400 to-lime-300",
    },
    {
      label: (
        <div className="w-[40px] h-[40px] rounded-[50%] bg-gradient-to-r from-blue-600 to-sky-400"></div>
      ),
      key: "bg-gradient-to-r from-blue-600 to-sky-400",
    },
  ]
  const dispatch = useAppDispatch()
  const handleMenuClick = (e: { key: string }) => {
    console.log(e.key);
    dispatch(setThemeColor(e.key))
  };

  return (
    <Dropdown menu={{ items, onClick:  handleMenuClick}}>
      <a onClick={(e) => e.preventDefault()}>
        <Space>
          <div>
            <Settings className="text-white w-10 h-10 cursor-pointer" />
          </div>
        </Space>
      </a>
    </Dropdown>
  )
}

export default MenuColor
