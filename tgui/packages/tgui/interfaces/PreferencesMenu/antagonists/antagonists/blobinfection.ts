import { Antagonist, Category } from '../base';
import { BLOB_MECHANICAL_DESCRIPTION } from './blob';

const BlobInfection: Antagonist = {
  key: 'blobinfection',
  name: '真菌感染',
  description: [
    `
      在一次轮班的任何时刻，都可能发生真菌感染，这种感染会让你化身恐怖的真菌体.
    `,
    BLOB_MECHANICAL_DESCRIPTION,
  ],
  category: Category.Midround,
};

export default BlobInfection;
