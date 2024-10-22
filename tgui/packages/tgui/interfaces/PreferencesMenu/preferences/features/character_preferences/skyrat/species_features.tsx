// THIS IS A SKYRAT UI FILE
import {
  CheckboxInput,
  Feature,
  FeatureChoiced,
  FeatureChoicedServerData,
  FeatureColorInput,
  FeatureNumberInput,
  FeatureShortTextInput,
  FeatureTextInput,
  FeatureToggle,
  FeatureTriBoolInput,
  FeatureTriColorInput,
  FeatureValueProps,
} from '../../base';
import { FeatureDropdownInput } from '../../dropdowns';

export const feature_leg_type: FeatureChoiced = {
  name: 'Leg type',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const feature_mcolor2: Feature<string> = {
  name: 'Mutant color 2',
  component: FeatureColorInput,
};
export const feature_mcolor3: Feature<string> = {
  name: 'Mutant color 3',
  component: FeatureColorInput,
};

export const flavor_text: Feature<string> = {
  name: '描述文本',
  description:
    '当你的角色被检视时会显示 (但只会出现在该角色可被辨认的情况下 - 比如没有面罩遮脸).',
  component: FeatureTextInput,
};

export const silicon_flavor_text: Feature<string> = {
  name: '描述文本 (硅基)',
  description: '只会在你扮演赛博格/AI时显示.',
  component: FeatureTextInput,
};

export const ooc_notes: Feature<string> = {
  name: 'OOC注释',
  component: FeatureTextInput,
};

export const custom_species: Feature<string> = {
  name: '自定义种族名',
  description: '在检视时显示，如果为空，就使用默认名称，如:人类、蜥蜴人等等.',
  component: FeatureShortTextInput,
};

export const custom_species_lore: Feature<string> = {
  name: '自定义种族历史',
  description: '当你没有自定义种族时就不会出现.',
  component: FeatureTextInput,
};

export const custom_taste: Feature<string> = {
  name: '角色味道',
  description: '如果有东西舔你的角色会尝到什么味道.',
  component: FeatureShortTextInput,
};

export const custom_smell: Feature<string> = {
  name: '角色气味',
  description: '如果有东西嗅你的角色会闻到什么味道.',
  component: FeatureShortTextInput,
};

export const general_record: Feature<string> = {
  name: '档案 - 通用',
  description:
    '可通过任何档案台查询. \
  内容关于就业履历, 能力资格等.',
  component: FeatureTextInput,
};

export const security_record: Feature<string> = {
  name: '档案 - 安保',
  description:
    '可通过安全档案台查询. \
  内容关于犯罪记录, 前科案底等.',
  component: FeatureTextInput,
};

export const medical_record: Feature<string> = {
  name: '档案 - 医疗',
  description:
    '可通过医疗档案台查询. \
  内容关于病史, 正在进行的治疗, DNR(不要复活)告知等.',
  component: FeatureTextInput,
};

export const exploitable_info: Feature<string> = {
  name: '信息 - 可被利用',
  description:
    '可以是IC或OOC内容. 反派/自定义反派以及幽灵可以看到. 一般是你的弱点、优势或重要背景等.\
  也可以是你的反派偏好，例如: 你是否想遭遇反派，遭遇何种反派，以什么方式被反派袭击.',
  component: FeatureTextInput,
};

export const background_info: Feature<string> = {
  name: '信息 - 背景',
  description:
    '只有你和幽灵可以看到，在这里你可以写下任何你想要的东西，这一般用于提醒你自己如何扮演.',
  component: FeatureTextInput,
};

export const pda_ringer: Feature<string> = {
  name: 'PDA拟声词',
  description: '你想让PDA发出"beep"以外的声音吗? 限定20个字符长度.',
  component: FeatureShortTextInput,
};

export const allow_mismatched_parts_toggle: FeatureToggle = {
  name: '允许非同种族的身体部件',
  description: '允许你身上出现其他种族的身体部位.',
  component: CheckboxInput,
};

export const allow_mismatched_hair_color_toggle: FeatureToggle = {
  name: '允许不匹配发色',
  description:
    '允许让固定发色的种族也能拥有不同发色，这也包括局内来源，比如染发、理发等，目前只有史莱姆人需要用到.',
  component: CheckboxInput,
};

export const allow_genitals_toggle: FeatureToggle = {
  name: 'Allow Genital Parts',
  description: 'Enables if you want to have genitals on your character.',
  component: CheckboxInput,
};

export const allow_emissives_toggle: FeatureToggle = {
  name: '允许自发光',
  description: '会在黑暗中发光.',
  component: CheckboxInput,
};

export const eye_emissives: FeatureToggle = {
  name: '瞳孔自发光',
  description: '会在黑暗中发光.',
  component: CheckboxInput,
};

export const mutant_colors_color: Feature<string[]> = {
  name: '突变颜色',
  component: FeatureTriColorInput,
};

export const body_markings_toggle: FeatureToggle = {
  name: '纹身',
  component: CheckboxInput,
};

export const feature_body_markings: Feature<string> = {
  name: '纹身选择',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const body_markings_color: Feature<string[]> = {
  name: '纹身颜色',
  component: FeatureTriColorInput,
};

export const body_markings_emissive: Feature<boolean[]> = {
  name: '纹身自发光',
  component: FeatureTriBoolInput,
};

export const tail_toggle: FeatureToggle = {
  name: '尾巴',
  component: CheckboxInput,
};

export const feature_tail: Feature<string> = {
  name: '尾巴选择',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const tail_color: Feature<string[]> = {
  name: '尾巴颜色',
  component: FeatureTriColorInput,
};

export const tail_emissive: Feature<boolean[]> = {
  name: '尾巴自发光',
  description: '会在黑暗中发光.',
  component: FeatureTriBoolInput,
};

export const snout_toggle: FeatureToggle = {
  name: '鼻子',
  component: CheckboxInput,
};

export const feature_snout: Feature<string> = {
  name: '鼻子选择',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const snout_color: Feature<string[]> = {
  name: '鼻子颜色',
  component: FeatureTriColorInput,
};

export const snout_emissive: Feature<boolean[]> = {
  name: '鼻子自发光',
  description: '会在黑暗中发光.',
  component: FeatureTriBoolInput,
};

export const horns_toggle: FeatureToggle = {
  name: '角',
  component: CheckboxInput,
};

export const feature_horns: Feature<string> = {
  name: '角选择',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const horns_color: Feature<string[]> = {
  name: '角颜色',
  component: FeatureTriColorInput,
};

export const horns_emissive: Feature<boolean[]> = {
  name: '角自发光',
  description: '会在黑暗中发光.',
  component: FeatureTriBoolInput,
};

export const ears_toggle: FeatureToggle = {
  name: '耳朵',
  component: CheckboxInput,
};

export const feature_ears: Feature<string> = {
  name: '耳朵选择',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const ears_color: Feature<string[]> = {
  name: '耳朵颜色',
  component: FeatureTriColorInput,
};

export const ears_emissive: Feature<boolean[]> = {
  name: '耳朵自发光',
  description: '会在黑暗中发光.',
  component: FeatureTriBoolInput,
};

export const wings_toggle: FeatureToggle = {
  name: '翅膀',
  component: CheckboxInput,
};

export const feature_wings: Feature<string> = {
  name: '翅膀选择',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const wings_color: Feature<string[]> = {
  name: '翅膀颜色',
  component: FeatureTriColorInput,
};

export const wings_emissive: Feature<boolean[]> = {
  name: '翅膀自发光',
  description: '会在黑暗中发光.',
  component: FeatureTriBoolInput,
};

export const frills_toggle: FeatureToggle = {
  name: '褶边',
  component: CheckboxInput,
};

export const feature_frills: Feature<string> = {
  name: '褶边选择',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const frills_color: Feature<string[]> = {
  name: '褶边颜色',
  component: FeatureTriColorInput,
};

export const frills_emissive: Feature<boolean[]> = {
  name: '褶边自发光',
  description: '会在黑暗中发光.',
  component: FeatureTriBoolInput,
};

export const spines_toggle: FeatureToggle = {
  name: 'Spines',
  component: CheckboxInput,
};

export const feature_spines: Feature<string> = {
  name: 'Spines Selection',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const spines_color: Feature<string[]> = {
  name: 'Spines Colors',
  component: FeatureTriColorInput,
};

export const spines_emissive: Feature<boolean[]> = {
  name: 'Spines Emissives',
  description: '会在黑暗中发光.',
  component: FeatureTriBoolInput,
};

export const digitigrade_legs: FeatureChoiced = {
  name: 'Legs',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const caps_toggle: FeatureToggle = {
  name: 'Cap',
  component: CheckboxInput,
};

export const feature_caps: Feature<string> = {
  name: 'Cap Selection',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const caps_color: Feature<string[]> = {
  name: 'Cap Colors',
  component: FeatureTriColorInput,
};

export const caps_emissive: Feature<boolean[]> = {
  name: 'Caps Emissives',
  description: '会在黑暗中发光.',
  component: FeatureTriBoolInput,
};

export const moth_antennae_toggle: FeatureToggle = {
  name: 'Moth Antenna',
  component: CheckboxInput,
};

export const feature_moth_antennae: Feature<string> = {
  name: 'Moth Antenna Selection',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const moth_antennae_color: Feature<string[]> = {
  name: 'Moth Antenna Colors',
  component: FeatureTriColorInput,
};

export const moth_antennae_emissive: Feature<boolean[]> = {
  name: 'Moth Antenna Emissives',
  description: '会在黑暗中发光.',
  component: FeatureTriBoolInput,
};

export const moth_markings_toggle: FeatureToggle = {
  name: 'Moth Markings',
  component: CheckboxInput,
};

export const feature_moth_markings: Feature<string> = {
  name: 'Moth Markings Selection',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const moth_markings_color: Feature<string[]> = {
  name: 'Moth Markings Colors',
  component: FeatureTriColorInput,
};

export const moth_markings_emissive: Feature<boolean[]> = {
  name: 'Moth Markings Emissives',
  description: '会在黑暗中发光.',
  component: FeatureTriBoolInput,
};

export const fluff_toggle: FeatureToggle = {
  name: 'Fluff',
  component: CheckboxInput,
};

export const feature_fluff: Feature<string> = {
  name: 'Fluff Selection',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const fluff_color: Feature<string[]> = {
  name: 'Fluff Colors',
  component: FeatureTriColorInput,
};

export const fluff_emissive: Feature<boolean[]> = {
  name: 'Fluff Emissives',
  description: '会在黑暗中发光.',
  component: FeatureTriBoolInput,
};

export const head_acc_toggle: FeatureToggle = {
  name: 'Head Accessories',
  component: CheckboxInput,
};

export const feature_head_acc: Feature<string> = {
  name: 'Head Accessories Selection',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const head_acc_color: Feature<string[]> = {
  name: 'Head Accessories Colors',
  component: FeatureTriColorInput,
};

export const head_acc_emissive: Feature<boolean[]> = {
  name: 'Head Accessories Emissives',
  description: '会在黑暗中发光.',
  component: FeatureTriBoolInput,
};

export const feature_ipc_screen: Feature<string> = {
  name: 'IPC Screen Selection',
  description: 'Can be changed in-round.',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const ipc_screen_color: Feature<string> = {
  name: 'IPC Screen Greyscale Color',
  component: FeatureColorInput,
};

export const ipc_screen_emissive: Feature<boolean> = {
  name: 'IPC Screen Emissive',
  description: '会在黑暗中发光.',
  component: CheckboxInput,
};

export const ipc_antenna_toggle: FeatureToggle = {
  name: 'Synth Antenna',
  component: CheckboxInput,
};

export const feature_ipc_antenna: Feature<string> = {
  name: 'Synth Antenna Selection',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const ipc_antenna_color: Feature<string[]> = {
  name: 'Synth Antenna Colors',
  component: FeatureTriColorInput,
};

export const ipc_antenna_emissive: Feature<boolean[]> = {
  name: 'Synth Antenna Emissives',
  description: '会在黑暗中发光.',
  component: FeatureTriBoolInput,
};

export const feature_ipc_chassis: Feature<string> = {
  name: 'Synth Chassis Selection',
  description: 'Only works for synths.',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const ipc_chassis_color: Feature<string> = {
  name: 'Synth Chassis Colors',
  description:
    'Only works for Synths and chassis that support greyscale coloring.',
  component: FeatureColorInput,
};

export const feature_ipc_head: Feature<string> = {
  name: 'Synth Head Selection',
  description: 'Only works for Synths.',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const ipc_head_color: Feature<string> = {
  name: 'Synth Head Colors',
  component: FeatureColorInput,
};

export const feature_hair_opacity_toggle: Feature<boolean> = {
  name: 'Hair Opacity Override',
  component: CheckboxInput,
};

export const feature_hair_opacity: Feature<number> = {
  name: 'Hair Opacity',
  component: FeatureNumberInput,
};

export const neck_acc_toggle: FeatureToggle = {
  name: 'Neck Accessories',
  component: CheckboxInput,
};

export const feature_neck_acc: Feature<string> = {
  name: 'Neck Accessories Selection',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const neck_acc_color: Feature<string[]> = {
  name: 'Neck Accessories Colors',
  component: FeatureTriColorInput,
};

export const neck_acc_emissive: Feature<boolean[]> = {
  name: 'Neck Accessories Emissives',
  component: FeatureTriBoolInput,
};

export const skrell_hair_toggle: FeatureToggle = {
  name: 'Skrell Hair',
  component: CheckboxInput,
};

export const feature_skrell_hair: Feature<string> = {
  name: 'Skrell Hair Selection',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const skrell_hair_color: Feature<string[]> = {
  name: 'Skrell Hair Colors',
  component: FeatureTriColorInput,
};

export const skrell_hair_emissive: Feature<boolean[]> = {
  name: 'Skrell Hair Emissives',
  description: '会在黑暗中发光.',
  component: FeatureTriBoolInput,
};

export const taur_toggle: FeatureToggle = {
  name: 'Taur',
  component: CheckboxInput,
};

export const feature_taur: Feature<string> = {
  name: 'Taur Selection',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const taur_color: Feature<string[]> = {
  name: 'Taur Colors',
  component: FeatureTriColorInput,
};

export const taur_emissive: Feature<boolean[]> = {
  name: 'Taur Emissives',
  description: '会在黑暗中发光.',
  component: FeatureTriBoolInput,
};

export const naga_sole: FeatureToggle = {
  name: 'Taur (Naga) disable hardened soles',
  description:
    'If using a serpentine taur body, determines if you are immune to caltrops and a few other effects of being barefoot.',
  component: CheckboxInput,
};

export const xenodorsal_toggle: FeatureToggle = {
  name: 'Xenodorsal',
  component: CheckboxInput,
};

export const feature_xenodorsal: Feature<string> = {
  name: 'Xenodorsal Selection',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const xenodorsal_color: Feature<string[]> = {
  name: 'Xenodorsal Colors',
  component: FeatureTriColorInput,
};

export const xenodorsal_emissive: Feature<boolean[]> = {
  name: 'Xenodorsal Emissives',
  description: '会在黑暗中发光.',
  component: FeatureTriBoolInput,
};

export const xenohead_toggle: FeatureToggle = {
  name: 'Xeno Head',
  component: CheckboxInput,
};

export const feature_xenohead: Feature<string> = {
  name: 'Xeno Head Selection',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const xenohead_color: Feature<string[]> = {
  name: 'Xeno Head Colors',
  component: FeatureTriColorInput,
};

export const xenohead_emissive: Feature<boolean[]> = {
  name: 'Xeno Head Emissives',
  description: '会在黑暗中发光.',
  component: FeatureTriBoolInput,
};

export const undershirt_color: Feature<string> = {
  name: 'Undershirt color',
  component: FeatureColorInput,
};

export const socks_color: Feature<string> = {
  name: 'Socks color',
  component: FeatureColorInput,
};

export const heterochromia_toggle: FeatureToggle = {
  name: 'Heterochromia',
  component: CheckboxInput,
};

export const feature_heterochromia: Feature<string> = {
  name: 'Heterochromia Selection',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const heterochromia_color: Feature<string[]> = {
  name: 'Heterochromia Colors',
  component: FeatureTriColorInput,
};

export const heterochromia_emissive: Feature<boolean[]> = {
  name: 'Heterochromia Emissives',
  description: '会在黑暗中发光.',
  component: FeatureTriBoolInput,
};

export const vox_bodycolor: Feature<string> = {
  name: 'Vox Bodycolor',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const pod_hair_color: Feature<string[]> = {
  name: 'Floral Hair Color',
  component: FeatureTriColorInput,
};

export const pod_hair_emissive: Feature<boolean> = {
  name: 'Floral Hair Emissive',
  description: '会在黑暗中发光.',
  component: CheckboxInput,
};
