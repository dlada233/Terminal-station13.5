import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import {
  Button,
  ColorBox,
  Input,
  LabeledList,
  NumberInput,
  Section,
} from '../components';
import { Window } from '../layouts';

type EyeColorData = {
  mode: BooleanLike;
  hasOwner: BooleanLike;
  left: string;
  right: string;
};

type Data = {
  eyeColor: EyeColorData;
  lightColor: string;
  range: number;
};

enum ToUpdate {
  LightColor,
  LeftEye,
  RightEye,
}

const LightColorDisplay = (props) => {
  const { act, data } = useBackend<Data>();
  const { lightColor } = data;
  return (
    <LabeledList.Item label="颜色">
      <ColorBox color={lightColor} />{' '}
      <Button
        icon="palette"
        onClick={() => act('pick_color', { to_update: ToUpdate.LightColor })}
        tooltip="调出颜色编辑器以更改发光颜色"
      />
      <Button
        icon="dice"
        onClick={() => act('random_color', { to_update: ToUpdate.LightColor })}
        tooltip="随机发光颜色."
      />
      <Input
        value={lightColor}
        width={6}
        maxLength={7}
        onChange={(_, value) =>
          act('enter_color', {
            new_color: value,
            to_update: ToUpdate.LightColor,
          })
        }
      />
    </LabeledList.Item>
  );
};

const RangeDisplay = (props) => {
  const { act, data } = useBackend<Data>();
  const { range } = data;
  return (
    <LabeledList.Item label="范围">
      <Button
        icon="minus-square-o"
        onClick={() => act('set_range', { new_range: range - 1 })}
        tooltip="减少光照范围."
      />
      <Button
        icon="plus-square-o"
        onClick={() => act('set_range', { new_range: range + 1 })}
        tooltip="增加光照范围."
      />
      <NumberInput
        animated
        width="35px"
        step={1}
        stepPixelSize={5}
        value={range}
        minValue={0}
        maxValue={5}
        onDrag={(value) =>
          act('set_range', {
            new_range: value,
          })
        }
      />
    </LabeledList.Item>
  );
};

const EyeColorDisplay = (props) => {
  const { act, data } = useBackend<Data>();
  const { eyeColor } = data;
  return (
    <>
      <LabeledList.Item label="颜色匹配">
        <Button.Checkbox
          checked={eyeColor.mode}
          onClick={() => act('toggle_eye_color')}
          tooltip="开关眼睛颜色是否与发光颜色匹配."
        />
      </LabeledList.Item>
      {!eyeColor.mode && (
        <>
          <LabeledList.Item label="左眼">
            <ColorBox color={eyeColor.left} />{' '}
            <Button
              icon="palette"
              onClick={() => act('pick_color', { to_update: ToUpdate.LeftEye })}
              tooltip="调出颜色编辑器以更改发光颜色."
            />
            <Button
              icon="dice"
              onClick={() =>
                act('random_color', { to_update: ToUpdate.LeftEye })
              }
              tooltip="随机该眼睛颜色."
            />
            <Input
              value={eyeColor.left}
              width={6}
              maxLength={7}
              onChange={(_, value) =>
                act('enter_color', {
                  new_color: value,
                  to_update: ToUpdate.LeftEye,
                })
              }
            />
          </LabeledList.Item>
          <LabeledList.Item label="右眼">
            <ColorBox color={eyeColor.right} />{' '}
            <Button
              icon="palette"
              onClick={() =>
                act('pick_color', { to_update: ToUpdate.RightEye })
              }
              tooltip="调出颜色编辑器以更改发光颜色."
            />
            <Button
              icon="dice"
              onClick={() =>
                act('random_color', { to_update: ToUpdate.RightEye })
              }
              tooltip="随机该眼睛颜色."
            />
            <Input
              value={eyeColor.right}
              width={6}
              maxLength={7}
              onChange={(_, value) =>
                act('enter_color', {
                  new_color: value,
                  to_update: ToUpdate.RightEye,
                })
              }
            />
          </LabeledList.Item>
        </>
      )}
    </>
  );
};

export const HighLuminosityEyesMenu = (props) => {
  const { act, data } = useBackend<Data>();
  const { eyeColor } = data;
  return (
    <Window
      title="高亮眼睛"
      width={eyeColor.hasOwner ? 262 : 225}
      height={eyeColor.hasOwner ? (eyeColor.mode ? 170 : 220) : 135}
    >
      <Window.Content>
        <Section fill title="设置">
          <LabeledList>
            <LightColorDisplay />
            <RangeDisplay />
            {!!eyeColor.hasOwner && <EyeColorDisplay />}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
