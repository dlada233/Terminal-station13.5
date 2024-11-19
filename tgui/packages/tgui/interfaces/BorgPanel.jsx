import { useBackend } from '../backend';
import { Box, Button, LabeledList, ProgressBar, Section } from '../components';
import { Window } from '../layouts';

export const BorgPanel = (props) => {
  const { act, data } = useBackend();
  const borg = data.borg || {};
  const cell = data.cell || {};
  const cellPercent = cell.charge / cell.maxcharge;
  const channels = data.channels || [];
  const modules = data.modules || [];
  const upgrades = data.upgrades || [];
  const ais = data.ais || [];
  const laws = data.laws || [];
  return (
    <Window title="赛博格面板" theme="admin" width={700} height={700}>
      <Window.Content scrollable>
        <Section
          title={borg.name}
          buttons={
            <Button
              icon="pencil-alt"
              content="重命名"
              onClick={() => act('rename')}
            />
          }
        >
          <LabeledList>
            <LabeledList.Item label="状态">
              <Button
                icon={borg.emagged ? 'check-square-o' : 'square-o'}
                content="Emagged"
                selected={borg.emagged}
                onClick={() => act('toggle_emagged')}
              />
              <Button
                icon={borg.lockdown ? 'check-square-o' : 'square-o'}
                content="锁定"
                selected={borg.lockdown}
                onClick={() => act('toggle_lockdown')}
              />
              <Button
                icon={borg.scrambledcodes ? 'check-square-o' : 'square-o'}
                content="代码遭扰乱"
                selected={borg.scrambledcodes}
                onClick={() => act('toggle_scrambledcodes')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="充能">
              {!cell.missing ? (
                <ProgressBar value={cellPercent}>
                  {cell.charge + ' / ' + cell.maxcharge}
                </ProgressBar>
              ) : (
                <span className="color-bad">No cell installed</span>
              )}
              <br />
              <Button
                icon="pencil-alt"
                content="设置"
                onClick={() => act('set_charge')}
              />
              <Button
                icon="eject"
                content="更换"
                onClick={() => act('change_cell')}
              />
              <Button
                icon="trash"
                content="移除"
                color="bad"
                onClick={() => act('remove_cell')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="无线电频道">
              {channels.map((channel) => (
                <Button
                  key={channel.name}
                  icon={channel.installed ? 'check-square-o' : 'square-o'}
                  content={channel.name}
                  selected={channel.installed}
                  onClick={() =>
                    act('toggle_radio', {
                      channel: channel.name,
                    })
                  }
                />
              ))}
            </LabeledList.Item>
            <LabeledList.Item label="模式">
              {modules.map((module) => (
                <Button
                  key={module.type}
                  icon={
                    borg.active_module === module.type
                      ? 'check-square-o'
                      : 'square-o'
                  }
                  content={module.name}
                  selected={borg.active_module === module.type}
                  onClick={() =>
                    act('setmodule', {
                      module: module.type,
                    })
                  }
                />
              ))}
            </LabeledList.Item>
            <LabeledList.Item label="升级">
              {upgrades.map((upgrade) => (
                <Button
                  key={upgrade.type}
                  icon={upgrade.installed ? 'check-square-o' : 'square-o'}
                  content={upgrade.name}
                  selected={upgrade.installed}
                  onClick={() =>
                    act('toggle_upgrade', {
                      upgrade: upgrade.type,
                    })
                  }
                />
              ))}
            </LabeledList.Item>
            <LabeledList.Item label="上级AI">
              {ais.map((ai) => (
                <Button
                  key={ai.ref}
                  icon={ai.connected ? 'check-square-o' : 'square-o'}
                  content={ai.name}
                  selected={ai.connected}
                  onClick={() =>
                    act('slavetoai', {
                      slavetoai: ai.ref,
                    })
                  }
                />
              ))}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section
          title="法律"
          buttons={
            <Button
              icon={borg.lawupdate ? 'check-square-o' : 'square-o'}
              content="Lawsync"
              selected={borg.lawupdate}
              onClick={() => act('toggle_lawupdate')}
            />
          }
        >
          {laws.map((law) => (
            <Box key={law}>{law}</Box>
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
};
