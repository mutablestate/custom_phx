module.exports = {
  theme: {
    extend: {
      colors: {
        phoenix: '#f67938'
      }
    },
    customForms: theme => ({
      default: {
        'input, textarea, multiselect, select, checkbox, radio': {
          boxShadow: theme('boxShadow.default'),
          borderRadius: theme('borderRadius.default'),
          borderColor: theme('colors.gray.400'),
          color: theme('colors.gray.600'),
          '&:focus': {
            outline: '0',
            boxShadow: theme('boxShadow.outline')
          },
          'input, textarea, multiselect, select': {
            display: 'block'
          },
          'checkbox, radio': {
            display: 'inline'
          }
        }
      }
    })
  },
  variants: {},
  plugins: [
    require('@tailwindcss/custom-forms'),
    function({ addUtilities, theme }) {
      const newUtilities = {
        '.form-label': {
          textTransform: 'uppercase',
          fontWeight: theme('fontWeight.bold'),
          fontSize: theme('fontSize.sm'),
          color: theme('colors.gray.600')
        }
      };
      addUtilities(newUtilities);
    }
  ]
};
