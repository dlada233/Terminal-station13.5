import { Antagonist, Category } from '../base';

const SpaceNinja: Antagonist = {
  key: 'spaceninja',
  name: '太空忍者',
  description: [
    `
      蜘蛛众为了更完美地贯彻后现代太空武士道，对肉体进行了无底线的赛博改造.
    `,

    `
      变成敏捷的赛博太空忍者. 用武士刀、手里剑进行战斗，用隐形、EMP等技能进行
      其他活动；你还有强大黑客手套，轻松骇入气闸与从APC处充电，若能骇入安保档案终端
      还能将所有人标记为逮捕，甚至若能骇入通信终端，将直接召唤更多威胁.
    `,
  ],
  category: Category.Midround,
};

export default SpaceNinja;
