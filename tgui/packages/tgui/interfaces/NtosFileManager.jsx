import { useBackend } from '../backend';
import { Button, Section, Table } from '../components';
import { NtosWindow } from '../layouts';

export const NtosFileManager = (props) => {
  const { act, data } = useBackend();
  const { usbconnected, files = [], usbfiles = [] } = data;
  return (
    <NtosWindow>
      <NtosWindow.Content scrollable>
        <Section>
          <FileTable
            files={files}
            usbconnected={usbconnected}
            onUpload={(file) => act('PRG_copytousb', { name: file })}
            onDelete={(file) => act('PRG_deletefile', { name: file })}
            onRename={(file, newName) =>
              act('PRG_renamefile', {
                name: file,
                new_name: newName,
              })
            }
            onDuplicate={(file) => act('PRG_clone', { file: file })}
            onToggleSilence={(file) => act('PRG_togglesilence', { name: file })}
          />
        </Section>
        {usbconnected && (
          <Section title="数据盘">
            <FileTable
              usbmode
              files={usbfiles}
              usbconnected={usbconnected}
              onUpload={(file) => act('PRG_copyfromusb', { name: file })}
              onDelete={(file) => act('PRG_usbdeletefile', { name: file })}
              onRename={(file, newName) =>
                act('PRG_usbrenamefile', {
                  name: file,
                  new_name: newName,
                })
              }
              onDuplicate={(file) => act('PRG_clone', { file: file })}
            />
          </Section>
        )}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

const FileTable = (props) => {
  const {
    files = [],
    usbconnected,
    usbmode,
    onUpload,
    onDelete,
    onRename,
    onToggleSilence,
  } = props;
  return (
    <Table>
      <Table.Row header>
        <Table.Cell>文件</Table.Cell>
        <Table.Cell collapsing>类型</Table.Cell>
        <Table.Cell collapsing>大小</Table.Cell>
      </Table.Row>
      {files.map((file) => (
        <Table.Row key={file.name} className="candystripe">
          <Table.Cell>
            {!file.undeletable ? (
              <Button.Input
                fluid
                content={file.name}
                currentValue={file.name}
                tooltip="重命名"
                onCommit={(e, value) => onRename(file.name, value)}
              />
            ) : (
              file.name
            )}
          </Table.Cell>
          <Table.Cell>{file.type}</Table.Cell>
          <Table.Cell>{file.size}</Table.Cell>
          <Table.Cell collapsing>
            {!!file.alert_able && (
              <Button
                icon={file.alert_silenced ? 'bell-slash' : 'bell'}
                color={file.alert_silenced ? 'red' : 'default'}
                tooltip={file.alert_silenced ? '取消静音' : '开启静音'}
                onClick={() => onToggleSilence(file.name)}
              />
            )}
            {!file.undeletable && (
              <>
                <Button.Confirm
                  icon="trash"
                  confirmIcon="times"
                  confirmContent=""
                  tooltip="删除"
                  onClick={() => onDelete(file.name)}
                />
                {!!usbconnected &&
                  (usbmode ? (
                    <Button
                      icon="download"
                      tooltip="下载"
                      onClick={() => onUpload(file.name)}
                    />
                  ) : (
                    <Button
                      icon="upload"
                      tooltip="上传"
                      onClick={() => onUpload(file.name)}
                    />
                  ))}
              </>
            )}
          </Table.Cell>
        </Table.Row>
      ))}
    </Table>
  );
};
