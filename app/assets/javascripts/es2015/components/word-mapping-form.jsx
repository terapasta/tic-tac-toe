import React, { Component, PropTypes } from 'react';
import styled from 'styled-components';

const blue = '#337ab7';

const Wrapper = styled.div`
  padding-bottom: 32px;
  margin-bottom: 32px;
  border-bottom: 1px solid #ddd;

  &:first-of-type {
    padding-top: 32px;
  }

  &:last-of-type {
    margin-bottom: 0;
    border-bottom: 0;
  }
`;

const Title = styled.div`
  position: relative;
  margin-bottom: 16px;
  font-size: 24px;

  ${props => props.editing && `
    margin-bottom: 32px;
  `}
`;

const Subtitle = styled.div`
  padding-bottom: 12px;
  color: #888;
`;

const Words = styled.ul`
  list-style: none;
  margin: 0;
  padding: 0;

  li {
    position: relative;
    margin: 0 8px 8px 0;
    display: inline-block;
  }
`;

const BaseWord = `
  padding: 8px 16px;
  border: 1px solid #ddd;
  border-radius: 3px;
`;

const Word = styled.li`
  ${BaseWord}
  cursor: text;

  &:hover {
    border-color: ${blue};
  }
`;

const InlineButton = styled.button`
  cursor: pointer;
  display: inline-block;
  padding: 0;
  margin: 0;
  background-color: transparent;
  border: 0;
  color: #888;

  &:hover {
    text-decoration: none;
    color: darken(#888, 10%);
  }

  i {
    position: relative;
    top: -1px;
    font-size: 16px;
  }
`;

const HelpText = styled.div`
  position: absolute;
  top: 100%;
  left: 0;
  right: 0;
  color: #888;
  font-size: 14px !important;
`;

const Input = styled.input`
  ${BaseWord}
  outline: none;

  &:focus {
    border: 1px solid ${blue};
  }
`;

class WordMappingForm extends Component {
  render() {
    const { id, word, synonyms } = this.props;

    return (
      <div>
      <Wrapper>
        <Title>
          {word}
          <InlineButton>
            <i className="material-icons mi-v-top">edit</i>
          </InlineButton>
        </Title>
        <Words>
          {synonyms.map((synonym) => (
            <Word key={synonym}>{synonym}</Word>
          ))}
        </Words>
      </Wrapper>
      </div>
    );
  }
}

WordMappingForm.componentName = 'WordMappingForm';

WordMappingForm.propTypes = {
  id: PropTypes.number.isRequired,
  word: PropTypes.string.isRequired,
  synonyms: PropTypes.arrayOf(PropTypes.shape({
    id: PropTypes.number.isRequired,
    value: PropTypes.string.isRequired,
  })),
};

export default WordMappingForm;
