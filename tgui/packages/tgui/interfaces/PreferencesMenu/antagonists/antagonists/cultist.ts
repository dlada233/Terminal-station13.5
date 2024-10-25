import { Antagonist, Category } from '../base';

const Cultist: Antagonist = {
  key: 'cultist',
  name: '血教徒',
  description: [
    `
      几何之血尊，Nar-Sie派遣了众多她的追随者来到13号空间站，作为一名血教徒你拥有
      大量的血魔法可供在任何情况下使用. 你必须与教友们合作，尝试召唤到那神秘女神的
      化身降临现世!
    `,

    `
      运用血魔法武装自身，让船员皈依血教或者直接献祭掉，并最终召唤出Nar-Sie.
    `,
  ],
  category: Category.Roundstart,
};

export default Cultist;
