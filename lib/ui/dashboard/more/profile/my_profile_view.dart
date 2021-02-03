import 'package:badhat_b2b/ui/dashboard/more/profile/my_profile_controller.dart';
import 'package:badhat_b2b/utils/contants.dart';
import 'package:badhat_b2b/widgets/widget_view.dart';
import 'package:flutter/material.dart';

import '../../../../utils/extensions.dart';

class MyProfileView extends WidgetView<MyProfileScreen, MyProfileScreenState> {
  MyProfileView(MyProfileScreenState state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(state.isEditing ? "Edit your Profile" : "My Profile"),
        leading: state.isEditing
            ? IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  state.populateData();
                  state.updateEditState(false);
                })
            : null,
        actions: [
          if (!state.isEditing)
            FlatButton.icon(
              onPressed: () {
                state.updateEditState(true);
              },
              label: Text("Edit"),
              icon: Icon(Icons.edit),
            ),
          if (state.isEditing)
            RaisedButton(
              onPressed: state.saving
                  ? () {}
                  : () {
                      state.updateProfile();
                    },
              child: state.saving
                  ? CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    )
                  : Text("Save"),
              color: Colors.green,
              textColor: Colors.white,
            )
        ],
      ),
      body: state.loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Form(
                key: state.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Container(
                        width: 118,
                        height: 118,
                        //color: Colors.grey.withOpacity(0.5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        child: Stack(
                          children: <Widget>[
                            InkWell(
                              onTap: state.isEditing
                                  ? () {
                                      state.launchImagePicker();
                                    }
                                  : null,
                              child: state.avatar == null
                                  ? state.profileData.image != null
                                      ? Image.network(
                                          state.profileData.image,
                                          height: 118,
                                          width: 118,
                                          fit: BoxFit.cover,
                                        )
                                      : Center(
                                          child: Text(
                                          state.isEditing
                                              ? "Add store image"
                                              : "Store Image",
                                          textAlign: TextAlign.center,
                                        ))
                                  : Image.file(
                                      state.avatar,
                                      height: 118,
                                      width: 118,
                                      fit: BoxFit.cover,
                                    ).container(width: 118, height: 118),
                            ),
                            if (state.isEditing)
                              Align(
                                alignment: Alignment.bottomRight,
                                child: CircleAvatar(
                                  radius: 10,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                              ).paddingFromLTRB(0, 0, 4, 4),
                          ],
                        ),
                      ),
                    ),
                    Text("Business Name").paddingAll(5),
                    TextFormField(
                      enabled: state.isEditing,
                      validator: (value) {
                        if (value.isEmpty) return "Enter Business name";
                        return null;
                      },
                      textInputAction: TextInputAction.done,
                      controller: state.businessNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        //hintText: "Business Name",
                        //labelText: "Business Name",
                      ),
                    ).paddingAll(4),
                    Text("GST Number").paddingAll(5),
                    TextFormField(
                      enabled: state.isEditing,
                      textInputAction: TextInputAction.done,
                      controller: state.gstinController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        //hintText: "GST Number",
                        //labelText: "GST Number",
                      ),
                    ).paddingAll(4),
                    Text("Owner Name").paddingAll(5),
                    TextFormField(
                      enabled: state.isEditing,
                      validator: (value) {
                        if (value.isEmpty) return "Enter Owner name";
                        return null;
                      },
                      textInputAction: TextInputAction.done,
                      controller: state.ownerNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        //hintText: "Owner Name",
                        //labelText: "Owner Name",
                      ),
                    ).paddingAll(4),

                    Text("Email").paddingAll(5),
                    TextFormField(
                      enabled: state.isEditing,
                      validator: (value) {
                        if (value.isNotEmpty && !value.validEmail())
                          return "Enter valid email";
                        return null;
                      },
                      textInputAction: TextInputAction.done,
                      controller: state.emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        //hintText: "Email",
                        //labelText: "Email",
                      ),
                    ).paddingAll(4),

                    Text("Mobile").paddingAll(5),
                    TextFormField(
                      enabled: state.isEditing,
                      validator: (value) {
                        if (value.length != 10)
                          return "Enter 10 digit mobile number";
                        return null;
                      },
                      keyboardType:
                          TextInputType.numberWithOptions(signed: true),
                      controller: state.mobileController,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        //hintText: "Mobile",
                        //labelText: "Mobile",
                      ),
                    ).paddingAll(4),
                    //Text("State & District").paddingAll(4),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("State").paddingAll(5),
                              DropdownButtonFormField(
                                      validator: (value) {
                                        if (value == null)
                                          return "Select State";
                                        return null;
                                      },
                                      isExpanded: true,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        //hintText: "State",
                                        //labelText: "State",
                                      ),
                                      onChanged: state.isEditing
                                          ? (stateName) {
                                              state.loadDistrict(stateName);
                                            }
                                          : null,
                                      value: state.selectedState,
                                      items: state.states
                                          .map((e) => DropdownMenuItem(
                                                value: e.state,
                                                child: Text(
                                                  e.state.trim(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ))
                                          .toList())
                                  .paddingAll(4),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("District").paddingAll(5),
                              DropdownButtonFormField(
                                validator: (value) {
                                  if (value == null) return "Select District";
                                  return null;
                                },
                                isExpanded: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  //hintText: "District",
                                  //labelText: "District",
                                ),
                                onChanged: state.isEditing
                                    ? (district) {
                                        state.updateSelectedDistrict(district);
                                      }
                                    : null,
                                value: state.selectedDistrict,
                                items: state.districts.map((e) {
                                  return DropdownMenuItem(
                                    child: Text(
                                      e,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    value: e,
                                  );
                                }).toList(),
                              ).paddingAll(4),
                            ],
                          ),
                        )
                      ],
                    ),
                    Text("Shop/House No & Street Name").paddingAll(5),
                    TextFormField(
                      enabled: state.isEditing,
                      textInputAction: TextInputAction.done,
                      controller: state.addressController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        //hintText: "Shop/House No & Street Name",
                        //labelText: "Shop/House No & Street Name",
                      ),
                    ).paddingAll(4),

                    Text("City/Town/Village Area").paddingAll(5),
                    TextFormField(
                      enabled: state.isEditing,
                      textInputAction: TextInputAction.done,
                      controller: state.cityController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        //hintText: "City/Town/Village Area",
                        //labelText: "City/Town/Village Area",
                      ),
                    ).paddingAll(4),
                    Text("Pincode").paddingAll(5),
                    TextFormField(
                      enabled: state.isEditing,
                      validator: (value) {
                        if (value.length != 6)
                          return "Enter valid 6 digit pincode";
                        return null;
                      },
                      textInputAction: TextInputAction.done,
                      controller: state.pincodeController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        //hintText: "Pincode",
                        //labelText: "Pincode",
                      ),
                    ).paddingAll(4),
                    Text("Business Type").paddingAll(5),
                    DropdownButtonFormField(
                      validator: (value) {
                        if (value == null) return "Select Business Type";
                        return null;
                      },
                      isExpanded: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        //hintText: "Business Type",
                        //labelText: "Business Type",
                      ),
                      onChanged: state.isEditing
                          ? (value) {
                              state.updateSelectedBusinessType(value);
                            }
                          : null,
                      value: state.selectedBusinessType,
                      items: userType.map((e) {
                        return DropdownMenuItem(
                          child: Text(
                            e,
                            overflow: TextOverflow.ellipsis,
                          ),
                          value: e,
                        );
                      }).toList(),
                    ).paddingAll(4),
                    Text("Business Category").paddingAll(5),
                    DropdownButtonFormField(
                      validator: (value) {
                        if (value == null) return "Select Business Category";
                        return null;
                      },
                      isExpanded: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        //hintText: "Business Category",
                        //labelText: "Business Category",
                      ),
                      onChanged: state.isEditing
                          ? (val) {
                              state.updateSelectedBusinessCategory(val);
                            }
                          : null,
                      value: state.selectedBusinessCategory,
                      items: state.businessCategories.map((e) {
                        return DropdownMenuItem(
                          child: Text(
                            e.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                          value: e.name,
                        );
                      }).toList(),
                    ).paddingAll(4),
                  ],
                ),
              ).paddingAll(8),
            ),
    );
  }
}
