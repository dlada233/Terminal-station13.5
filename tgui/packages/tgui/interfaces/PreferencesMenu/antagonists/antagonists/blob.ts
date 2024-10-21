import { Antagonist, Category } from '../base';

export const BLOB_MECHANICAL_DESCRIPTION = `
  真菌已经感染了空间站，它能摧毁扩张道路上的一切，无论是船体、机器还是生物.
  扩张群体，收集资源，最终吞噬整个空间站. 但要记得做好防御措施，因为船员们会察觉到
  你的存在并不惜一切代价消灭你!
`;

const Blob: Antagonist = {
  key: 'blob',
  name: '真菌',
  description: [BLOB_MECHANICAL_DESCRIPTION],
  category: Category.Midround,
};

export default Blob;
