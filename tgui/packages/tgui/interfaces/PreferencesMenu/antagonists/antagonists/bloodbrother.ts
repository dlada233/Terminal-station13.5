import { Antagonist, Category } from '../base';

const BloodBrother: Antagonist = {
  key: 'bloodbrother',
  name: '血亲兄弟',
  description: [
    `
      与其他船员结成血亲兄弟，结合你们所在不同部门的优势，互相把对方从监狱中解脱出来，
      并最终压垮空间站.
    `,
  ],
  category: Category.Roundstart,
};

export default BloodBrother;
