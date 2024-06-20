import React from 'react';
import type { MenuProps } from 'antd';
import { Menu } from 'antd';

type MenuItem = Required<MenuProps>['items'][number];

const items: MenuItem[] = [
  {
    key: 'sub4',
    label: 'Рейтинг сложности',
    style:{
        fontSize: '1.2em'
    },
    children: [
      { key: '1', label: '1★', style: { height: '28px', display: 'flex', justifyContent: 'center', alignItems:'center' }},
      { key: '2', label: '2★', style: { height: '28px', display: 'flex', justifyContent: 'center', alignItems:'center' } },
      { key: '3', label: '3★', style: { height: '28px', display: 'flex', justifyContent: 'center', alignItems:'center' } },
      { key: '4', label: '4★', style: { height: '28px', display: 'flex', justifyContent: 'center', alignItems:'center' } },
      { key: '5', label: '5★', style: { height: '28px', display: 'flex', justifyContent: 'center', alignItems:'center' } },
    ],
  },
];

const TaskRatingInput: React.FC = () => {
  const onClick: MenuProps['onClick'] = (e) => {
    console.log('click ', e);
  };

  return (
    <Menu
      onClick={onClick}
      style={{ width: '300px', height: '40px', border: '1px solid #ccc', borderRadius: '10px', display: 'flex', justifyContent: 'center', alignItems: 'center'}}
      defaultSelectedKeys={['1']}
      mode="horizontal"
      items={items}
    />
  );
};

export default TaskRatingInput;
 