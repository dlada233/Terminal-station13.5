import { useBackend } from '../../backend';
import {
  Box,
  Button,
  Chart,
  Flex,
  Icon,
  LabeledList,
  Tooltip,
} from '../../components';

export const RecipeLookup = (props) => {
  const { recipe, bookmarkedReactions } = props;
  const { act, data } = useBackend();
  if (!recipe) {
    return <Box>No reaction selected!</Box>;
  }

  const getReaction = (id) => {
    return data.master_reaction_list.filter((reaction) => reaction.id === id);
  };

  const addBookmark = (bookmark) => {
    bookmarkedReactions.add(bookmark);
  };

  return (
    <LabeledList>
      <LabeledList.Item bold label="配方名称">
        <Icon name="circle" mr={1} color={recipe.reagentCol} />
        {recipe.name}
        <Button
          icon="arrow-left"
          ml={3}
          disabled={recipe.subReactIndex === 1}
          onClick={() =>
            act('reduce_index', {
              id: recipe.name,
            })
          }
        />
        <Button
          icon="arrow-right"
          disabled={recipe.subReactIndex === recipe.subReactLen}
          onClick={() =>
            act('increment_index', {
              id: recipe.name,
            })
          }
        />
        {bookmarkedReactions && (
          <Button
            icon="book"
            color="green"
            disabled={bookmarkedReactions.has(getReaction(recipe.id)[0])}
            onClick={() => {
              addBookmark(getReaction(recipe.id)[0]);
              act('update_ui');
            }}
          />
        )}
      </LabeledList.Item>
      {recipe.products && (
        <LabeledList.Item bold label="产出物">
          {recipe.products.map((product) => (
            <Button
              key={product.name}
              icon="vial"
              disabled={product.hasProduct}
              content={product.ratio + 'u ' + product.name}
              onClick={() =>
                act('reagent_click', {
                  id: product.id,
                })
              }
            />
          ))}
        </LabeledList.Item>
      )}
      <LabeledList.Item bold label="反应物">
        {recipe.reactants.map((reactant) => (
          <Box key={reactant.id}>
            <Button
              icon="vial"
              color={reactant.color}
              content={reactant.ratio + 'u ' + reactant.name}
              onClick={() =>
                act('reagent_click', {
                  id: reactant.id,
                })
              }
            />
            {!!reactant.tooltipBool && (
              <Button
                icon="flask"
                color="purple"
                tooltip={reactant.tooltip}
                tooltipPosition="right"
                onClick={() =>
                  act('find_reagent_reaction', {
                    id: reactant.id,
                  })
                }
              />
            )}
          </Box>
        ))}
      </LabeledList.Item>
      {recipe.catalysts && (
        <LabeledList.Item bold label="催化剂">
          {recipe.catalysts.map((catalyst) => (
            <Box key={catalyst.id}>
              {(catalyst.tooltipBool && (
                <Button
                  icon="vial"
                  color={catalyst.color}
                  content={catalyst.ratio + 'u ' + catalyst.name}
                  tooltip={catalyst.tooltip}
                  tooltipPosition={'right'}
                  onClick={() =>
                    act('reagent_click', {
                      id: catalyst.id,
                    })
                  }
                />
              )) || (
                <Button
                  icon="vial"
                  color={catalyst.color}
                  content={catalyst.ratio + 'u ' + catalyst.name}
                  onClick={() =>
                    act('reagent_click', {
                      id: catalyst.id,
                    })
                  }
                />
              )}
            </Box>
          ))}
        </LabeledList.Item>
      )}
      {recipe.reqContainer && (
        <LabeledList.Item bold label="容器">
          <Button
            color="transparent"
            textColor="white"
            tooltipPosition="right"
            content={recipe.reqContainer}
            tooltip="发生此反应所需容器."
          />
        </LabeledList.Item>
      )}
      <LabeledList.Item bold label="纯度信息">
        <LabeledList>
          <LabeledList.Item label="最佳pH范围">
            <Box position="relative">
              <Tooltip content="如果你能将反应保持在范围内，产物的纯度将是100%.">
                {recipe.lowerpH + '-' + recipe.upperpH}
              </Tooltip>
            </Box>
          </LabeledList.Item>
          {!!recipe.inversePurity && (
            <LabeledList.Item label="反纯度">
              <Box position="relative">
                <Tooltip content="如果你的纯度低于此值，它将在消耗时100%转化为产物的相关反试剂.">
                  {`<${recipe.inversePurity * 100}%`}
                </Tooltip>
              </Box>
            </LabeledList.Item>
          )}
          {!!recipe.minPurity && (
            <LabeledList.Item label="最低纯度">
              <Box position="relative">
                <Tooltip content="如果纯度在反应过程中任意时间低于此值，会产生负面影响，如果在完成时仍低于此值，则产物将转化为相关失败试剂">
                  {`<${recipe.minPurity * 100}%`}
                </Tooltip>
              </Box>
            </LabeledList.Item>
          )}
        </LabeledList>
      </LabeledList.Item>
      <LabeledList.Item bold label="速率信息" width="10px">
        <Box
          height="50px"
          position="relative"
          style={{
            backgroundColor: 'black',
          }}
        >
          <Chart.Line
            fillPositionedParent
            data={recipe.thermodynamics}
            strokeWidth={0}
            fillColor={'#3cf072'}
          />
          {recipe.explosive && (
            <Chart.Line
              position="absolute"
              justify="right"
              top={0.01}
              bottom={0}
              right={recipe.isColdRecipe ? null : 0}
              width="28px"
              data={recipe.explosive}
              strokeWidth={0}
              fillColor={'#d92727'}
            />
          )}
        </Box>
        <Flex justify="space-between">
          <Tooltip
            content={
              recipe.isColdRecipe
                ? '温度过低，对反应产生负面影响.'
                : '该反应开始时所需的最低温度，超过该温度会加快反应速率.'
            }
          >
            <Flex.Item
              position="relative"
              textColor={recipe.isColdRecipe && 'red'}
            >
              {recipe.isColdRecipe
                ? recipe.explodeTemp + 'K'
                : recipe.tempMin + 'K'}
            </Flex.Item>
          </Tooltip>

          {recipe.explosive && (
            <Tooltip
              content={
                recipe.isColdRecipe
                  ? '该反应开始时所需的最低温度，超过该温度会加快反应速率.'
                  : '温度过热，对反应产生负面影响.'
              }
            >
              <Flex.Item
                position="relative"
                textColor={!recipe.isColdRecipe && 'red'}
              >
                {recipe.isColdRecipe
                  ? recipe.tempMin + 'K'
                  : recipe.explodeTemp + 'K'}
              </Flex.Item>
            </Tooltip>
          )}
        </Flex>
      </LabeledList.Item>
      <LabeledList.Item bold label="分子运动信息">
        <LabeledList>
          <LabeledList.Item label="最佳速率">
            <Tooltip content="以每秒为单位的最快反应速率. 是上方速率曲线中平直的区域.">
              <Box position="relative">{recipe.thermoUpper + 'u/s'}</Box>
            </Tooltip>
          </LabeledList.Item>
        </LabeledList>
        <Tooltip content="反应产生的热量 - 放热反应产生热量, 吸热反应消耗热量.">
          <Box position="relative">{recipe.thermics}</Box>
        </Tooltip>
      </LabeledList.Item>
    </LabeledList>
  );
};
