export enum Gender {
  Male = '男性',
  Female = '女性',
  Other = '多元',
  Other2 = '中性',
}

export const GENDERS = {
  [Gender.Male]: {
    icon: 'mars',
    text: 'He/Him',
  },

  [Gender.Female]: {
    icon: 'venus',
    text: 'She/Her',
  },

  [Gender.Other]: {
    icon: 'transgender',
    text: 'They/Them',
  },

  [Gender.Other2]: {
    icon: 'neuter',
    text: 'It/Its',
  },
};
