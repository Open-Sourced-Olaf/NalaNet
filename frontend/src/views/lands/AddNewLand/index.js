import React, { useState } from "react";
import {
  CButton,
  CCard,
  CCardBody,
  CCardFooter,
  CCardHeader,
  CCol,
  CCollapse,
  CDropdownItem,
  CDropdownMenu,
  CDropdownToggle,
  CFade,
  CForm,
  CFormGroup,
  CFormText,
  CValidFeedback,
  CInvalidFeedback,
  CTextarea,
  CInput,
  CInputFile,
  CInputCheckbox,
  CInputRadio,
  CInputGroup,
  CInputGroupAppend,
  CInputGroupPrepend,
  CDropdown,
  CInputGroupText,
  CLabel,
  CSelect,
  CRow,
  CSwitch,
} from "@coreui/react";
import CIcon from "@coreui/icons-react";

const AddNewLand = () => {
  return (
    <CCard>
      <CCardHeader>Add New Land</CCardHeader>
      <CCardBody>
        <CForm action="" method="post">
          <CFormGroup row className="my-0">
            <CCol xs="6">
              <CFormGroup>
                <CLabel htmlFor="nf-landid">Id</CLabel>
                <CInput
                  type="text"
                  id="nf-landid"
                  name="nf-landid"
                  placeholder="Id"
                  autoComplete="Id"
                />
              </CFormGroup>
            </CCol>
            <CCol xs="6">
              <CFormGroup>
                <CLabel htmlFor="nf-landsize">Size</CLabel>
                <CInput
                  type="text"
                  id="nf-landsize"
                  name="nf-landsize"
                  placeholder="Size"
                  autoComplete="size"
                />
              </CFormGroup>
            </CCol>
          </CFormGroup>
          <CFormGroup>
            <CLabel htmlFor="nf-location">Location</CLabel>
            <CInput
              type="text"
              id="nf-location"
              name="nf-location"
              placeholder="Location"
              autoComplete="Location"
            />
          </CFormGroup>

          <CFormGroup row className="my-0">
            <CCol xs="6">
              <CFormGroup>
                <CLabel htmlFor="nf-landowner">Owner</CLabel>
                <CInput
                  type="text"
                  id="nf-landowner"
                  name="nf-landowner"
                  placeholder="Owner"
                  autoComplete="Owner"
                />
              </CFormGroup>
            </CCol>
            <CCol xs="6">
              <CFormGroup>
                <CLabel htmlFor="nf-landuse">Use</CLabel>
                <CInput
                  type="text"
                  id="nf-landuse"
                  name="nf-landuse"
                  placeholder="Use"
                  autoComplete="use"
                />
              </CFormGroup>
            </CCol>
          </CFormGroup>

          <CCardFooter>
            <CButton type="submit" size="sm" color="primary">
              <CIcon name="cil-scrubber" /> Submit
            </CButton>{" "}
            <CButton type="reset" size="sm" color="danger">
              <CIcon name="cil-ban" /> Reset
            </CButton>
          </CCardFooter>
        </CForm>
      </CCardBody>
    </CCard>
  );
};

export default AddNewLand;
